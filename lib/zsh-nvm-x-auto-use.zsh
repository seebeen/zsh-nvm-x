autoload -U add-zsh-hook

_zsh_nvm_x_enable_auto_use() {
  # Avoid duplicate hooks when this file gets sourced more than once.
  if [[ "$_ZSH_NVM_X_AUTO_USE_HOOK_SET" != true ]]; then
    add-zsh-hook chpwd _zsh_nvm_x_auto_use
    _ZSH_NVM_X_AUTO_USE_HOOK_SET=true
  fi

  _zsh_nvm_x_auto_use
}

_zsh_nvm_x_auto_use() {
  _zsh_nvm_x_has nvm_find_nvmrc || return

  local nvmrc_path="$(nvm_find_nvmrc)"

  if [[ -n "$nvmrc_path" ]]; then
    local node_version="$(nvm version)"
    local nvmrc_node_version="$(nvm version "$(<"$nvmrc_path")")"

    if [[ "$nvmrc_node_version" = "N/A" ]]; then
      nvm install && export _ZSH_NVM_X_AUTO_USE_ACTIVE=true
    elif [[ "$nvmrc_node_version" != "$node_version" ]]; then
      nvm use && export _ZSH_NVM_X_AUTO_USE_ACTIVE=true
    fi
  elif [[ "$_ZSH_NVM_X_AUTO_USE_ACTIVE" == true ]]; then
    local node_version="$(nvm version)"
    local default_version="$(_zsh_nvm_x_default_version)"

    if [[ "$node_version" != "$default_version" ]]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi

    export _ZSH_NVM_X_AUTO_USE_ACTIVE=false
  fi
}
