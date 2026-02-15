_zsh_nvm_x_rename_function() {
  (( ${+functions[$1]} )) || return
  functions[$2]="${functions[$1]}"
  unset -f -- "$1"
}

_zsh_nvm_x_has() {
  type "$1" > /dev/null 2>&1
}

_zsh_nvm_x_latest_release_tag() {
  (
    builtin cd "$NVM_DIR" || return 1
    git fetch --quiet --tags origin
    git describe --abbrev=0 --tags --match "v[0-9]*" "$(git rev-list --tags --max-count=1)"
  )
}

_zsh_nvm_x_install() {
  echo "Installing nvm..."
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  (
    builtin cd "$NVM_DIR" || return 1
    git checkout --quiet "$(_zsh_nvm_x_latest_release_tag)"
  )
}

_zsh_nvm_x_invalidate_default_cache() {
  unset _ZSH_NVM_X_CACHED_DEFAULT_VERSION
}

_zsh_nvm_x_global_binaries() {
  local -a global_binary_paths global_binaries

  # Collect binary basenames using zsh glob qualifiers (`:t`) and dedupe in-shell.
  global_binary_paths=(
    "$NVM_DIR"/v0*/bin/*(N:t)
    "$NVM_DIR"/versions/*/*/bin/*(N:t)
  )
  (( ${#global_binary_paths[@]} )) || return

  typeset -U global_binaries
  global_binaries=("${global_binary_paths[@]}")
  print -l -- "${global_binaries[@]}"
}

_zsh_nvm_x_load() {

  # Source nvm (check if `nvm use` should be ran after load)
  if [[ "$NVM_NO_USE" == true ]]; then
    source "$NVM_DIR/nvm.sh" --no-use
  else
    source "$NVM_DIR/nvm.sh"
  fi

  # Rename main nvm function
  _zsh_nvm_x_rename_function nvm _zsh_nvm_x_nvm

  # Wrap nvm in our own function
  nvm() {
    case $1 in
      'upgrade')
        _zsh_nvm_x_upgrade
        ;;
      'revert')
        _zsh_nvm_x_revert
        ;;
      'use')
        _zsh_nvm_x_nvm "$@"
        export _ZSH_NVM_X_AUTO_USE_ACTIVE=false
        ;;
      'install' | 'i')
        _zsh_nvm_x_install_wrapper "$@"
        ;;
      'alias')
        _zsh_nvm_x_nvm "$@"
        [[ "$2" == "default" ]] && _zsh_nvm_x_invalidate_default_cache
        ;;
      'unalias')
        _zsh_nvm_x_nvm "$@"
        [[ "$2" == "default" ]] && _zsh_nvm_x_invalidate_default_cache
        ;;
      *)
        _zsh_nvm_x_nvm "$@"
        ;;
    esac
  }
}

_zsh_nvm_x_default_version() {
  if [[ -z "$_ZSH_NVM_X_CACHED_DEFAULT_VERSION" ]]; then
    _ZSH_NVM_X_CACHED_DEFAULT_VERSION="$(nvm version default)"
  fi
  print -r -- "$_ZSH_NVM_X_CACHED_DEFAULT_VERSION"
}

_zsh_nvm_x_completion() {

  # Add provided nvm completion
  [[ -r "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
}
