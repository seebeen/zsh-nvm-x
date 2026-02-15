nvm_update() {
  echo 'Deprecated, please use `nvm upgrade`'
}

_zsh_nvm_x_upgrade() {

  # Use default upgrade if it's built in
  local nvm_help_text
  nvm_help_text="$(_zsh_nvm_x_nvm help)"
  if [[ "$nvm_help_text" == *"nvm upgrade"* ]]; then
    _zsh_nvm_x_nvm upgrade
    return
  fi

  # Otherwise use our own
  local installed_version
  installed_version="$(builtin cd "$NVM_DIR" && git describe --tags)"
  echo "Installed version is $installed_version"
  echo "Checking latest version of nvm..."
  local latest_version=$(_zsh_nvm_x_latest_release_tag)
  if [[ "$installed_version" = "$latest_version" ]]; then
    echo "You're already up to date"
  else
    echo "Updating to $latest_version..."
    echo "$installed_version" > "$ZSH_NVM_DIR/previous_version"
    (
      builtin cd "$NVM_DIR" || return 1
      git fetch --quiet
      git checkout "$latest_version"
    )
    _zsh_nvm_x_load
  fi
}

_zsh_nvm_x_previous_version() {
  cat "$ZSH_NVM_DIR/previous_version" 2>/dev/null
}

_zsh_nvm_x_revert() {
  local previous_version="$(_zsh_nvm_x_previous_version)"
  if [[ -n "$previous_version" ]]; then
    local installed_version
    installed_version="$(builtin cd "$NVM_DIR" && git describe --tags)"
    if [[ "$installed_version" = "$previous_version" ]]; then
      echo "Already reverted to $installed_version"
      return
    fi
    echo "Installed version is $installed_version"
    echo "Reverting to $previous_version..."
    (
      builtin cd "$NVM_DIR" || return 1
      git checkout "$previous_version"
    )
    _zsh_nvm_x_load
  else
    echo "No previous version found"
  fi
}

_zsh_nvm_x_install_wrapper() {
  case $2 in
    'rc')
      NVM_NODEJS_ORG_MIRROR=https://nodejs.org/download/rc/ nvm install node && nvm alias rc "$(node --version)"
      echo "Clearing mirror cache..."
      nvm ls-remote > /dev/null 2>&1
      echo "Done!"
      ;;
    'nightly')
      NVM_NODEJS_ORG_MIRROR=https://nodejs.org/download/nightly/ nvm install node && nvm alias nightly "$(node --version)"
      echo "Clearing mirror cache..."
      nvm ls-remote > /dev/null 2>&1
      echo "Done!"
      ;;
    *)
      _zsh_nvm_x_nvm "$@"
      ;;
  esac
}
