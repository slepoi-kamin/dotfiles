#!/usr/bin/env bash

# safe-stow: A wrapper for GNU Stow that automatically backs up conflicting files

# Default options
TARGET_DIR="$HOME"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
VERBOSE=false
SIMULATE=false
ADOPT=false
DELETE=false
STOW_ARGS=()

# Function to print help
print_usage() {
  echo "Usage: $0 [options] [packages]"
  echo "A wrapper around GNU stow that automatically backs up conflicting files"
  echo ""
  echo "Options:"
  echo "  -t, --target DIR      Target directory (default: $HOME)"
  echo "  -b, --backup DIR      Backup directory (default: $HOME/.dotfiles_backup_TIMESTAMP)"
  echo "  -v, --verbose         Enable verbose output"
  echo "  -n, --no, --simulate  Simulate stow operation (don't make any changes)"
  echo "  -a, --adopt           Adopt existing files instead of backing them up"
  echo "  -D, --delete          Delete stowed links"
  echo "  -h, --help            Display this help message"
  echo ""
  echo "All other stow options are passed directly to stow"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)
      TARGET_DIR="$2"
      STOW_ARGS+=("-t" "$2")
      shift 2
      ;;
    -b|--backup)
      BACKUP_DIR="$2"
      shift 2
      ;;
    -v|--verbose)
      VERBOSE=true
      STOW_ARGS+=("-v")
      shift
      ;;
    -n|--no)
      SIMULATE=true
      STOW_ARGS+=("-n")
      shift
      ;;
    -a|--adopt)
      ADOPT=true
      STOW_ARGS+=("--adopt")
      shift
      ;;
    -D|--delete)
      DELETE=true
      STOW_ARGS+=("-D")
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    -*)
      # Pass any other options directly to stow
      STOW_ARGS+=("$1")
      shift
      ;;
    *)
      # This is a package name
      STOW_ARGS+=("$1")
      shift
      ;;
  esac
done

# Check if stow is installed
if ! command -v stow &> /dev/null; then
  echo "❌ GNU Stow is not installed. Please install it first."
  exit 1
fi

# If --adopt or --delete is specified, just pass through to stow
if [[ "$ADOPT" == "true" || "$DELETE" == "true" ]]; then
  if [[ "$VERBOSE" == "true" ]]; then
    echo "⏩ Passing through to stow with options: ${STOW_ARGS[*]}"
  fi
  stow "${STOW_ARGS[@]}"
  exit $?
fi

# Run stow in simulate mode to find conflicts
if [[ "$VERBOSE" == "true" ]]; then
  echo "🔍 Checking for conflicts..."
fi

# Save original args and force simulate mode for conflict check
ORIGINAL_ARGS=("${STOW_ARGS[@]}")
CONFLICT_ARGS=("-n" "-t" "$TARGET_DIR")
for arg in "${ORIGINAL_ARGS[@]}"; do
  if [[ "$arg" != "-n" && "$arg" != "--no" ]]; then
    CONFLICT_ARGS+=("$arg")
  fi
done

# Run stow in simulate mode to detect conflicts
CONFLICTS=$(stow "${CONFLICT_ARGS[@]}" 2>&1 | grep "cannot stow")

if [[ -n "$CONFLICTS" ]]; then
  if [[ "$SIMULATE" == "true" ]]; then
    echo "⚠️ Conflicts detected in simulation mode:"
    echo "$CONFLICTS"
    exit 1
  fi

  echo "⚠️ Conflicts detected. Backing up files to $BACKUP_DIR..."

  # Extract files that would conflict
  mkdir -p "$BACKUP_DIR"

  while IFS= read -r line; do
    # Extract the target file from different conflict message formats
    target_file=""
    
    if [[ "$line" == *"cannot stow"* ]]; then
      if [[ "$line" == *"over existing target"* ]]; then
        # Format: "cannot stow X over existing target Y"
        target_file=$(echo "$line" | sed -E 's/.*over existing target ([^ ]+).*/\1/')
      elif [[ "$line" == *"over existing directory target"* ]]; then
        # Format: "cannot stow non-directory X over existing directory target Y"
        target_file=$(echo "$line" | sed -E 's/.*over existing directory target ([^ ]+).*/\1/')
      fi
      
      # Remove any trailing punctuation
      target_file="${target_file%.}"
      target_file="${target_file%,}"
      
      if [[ -n "$target_file" ]]; then
        full_path="$TARGET_DIR/$target_file"
        backup_path="$BACKUP_DIR/$(dirname "$target_file")"
  
        if [[ -e "$full_path" ]]; then
          # Create the directory structure in the backup folder
          mkdir -p "$backup_path"
  
          # Handle different backup approaches for files and directories
          if [[ -d "$full_path" && ! -L "$full_path" ]]; then
            # For directories, copy then remove (preserve permissions)
            cp -a "$full_path" "$BACKUP_DIR/$target_file"
            rm -rf "$full_path"
            echo "   ✅ Backed up directory: $full_path → $BACKUP_DIR/$target_file"
          else
            # For files and symlinks, move them
            mv "$full_path" "$BACKUP_DIR/$target_file"
            echo "   ✅ Backed up: $full_path → $BACKUP_DIR/$target_file"
          fi
        fi
      fi
    fi
  done <<< "$CONFLICTS"

  echo "✅ Backup completed. Now running stow..."

  # Run the original stow command
  stow "${STOW_ARGS[@]}"
  STOW_EXIT=$?

  if [[ $STOW_EXIT -eq 0 ]]; then
    echo "✅ Stow completed successfully."
    echo "   Your original files are saved in: $BACKUP_DIR"
  else
    echo "❌ Stow failed with exit code $STOW_EXIT."
    echo "   Your original files are saved in: $BACKUP_DIR"
  fi

  exit $STOW_EXIT
fi

stow "${STOW_ARGS[@]}"
exit $?