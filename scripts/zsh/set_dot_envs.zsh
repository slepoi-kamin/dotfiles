set-dot-envs() {
  local files=() arg part               # итоговый список файлов
  local missing=0                       # 1, если какой-то из указанных файлов не найден

  ##########################
  # 1. Формируем список файлов
  ##########################

  if (( $# )); then                     # переданы аргументы → берём только их
    for arg in "$@"; do
      # поддержка "file1,file2" и "file1 file2"
      if [[ $arg == *,* ]]; then
        IFS=',' read -ra parts <<< "$arg"
        for part in "${parts[@]}"; do
          [[ -n $part ]] && files+=( "$part" )
        done
      else
        files+=( "$arg" )
      fi
    done
  else                                   # аргументов нет → ищем .env*
    if [[ -n $BASH_VERSION ]]; then
      shopt -s nullglob
      files=( .env* )
      shopt -u nullglob
    elif [[ -n $ZSH_VERSION ]]; then
      setopt NULL_GLOB
      files=( .env* )
      unsetopt NULL_GLOB
    fi
  fi

  ##########################
  # 2. Нет файлов → код 1
  ##########################
  if (( ${#files[@]} == 0 )); then
    echo "set-dot-envs: no .env* files found (or none of the specified files exist) in $(pwd)" >&2
    return 1
  fi

  ##########################
  # 3. Загружаем файлы
  ##########################
  set -a                                  # авто-export
  for file in "${files[@]}"; do
    if [[ -f $file ]]; then
      echo "→ sourcing $file"
      source "$file"
    else
      echo "set-dot-envs: file not found: $file" >&2
      missing=1
    fi
  done
  set +a                                  # выключаем авто-export

  ##########################
  # 4. Итоговый код возврата
  ##########################
  return $missing                         # 0 — всё ок, 1 — были пропущенные файлы
}