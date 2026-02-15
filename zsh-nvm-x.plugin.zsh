ZSH_NVM_X_DIR=${0:a:h}
# Keep this for compatibility with existing wrapper logic.
ZSH_NVM_DIR="$ZSH_NVM_X_DIR"

source "$ZSH_NVM_X_DIR/lib/zsh-nvm-x-state.zsh"
source "$ZSH_NVM_X_DIR/lib/zsh-nvm-x-core.zsh"
source "$ZSH_NVM_X_DIR/lib/zsh-nvm-x-wrappers.zsh"
source "$ZSH_NVM_X_DIR/lib/zsh-nvm-x-lazy.zsh"
source "$ZSH_NVM_X_DIR/lib/zsh-nvm-x-auto-use.zsh"

# Bootstrap only. All behavior lives in lib/*.zsh.
# Don't init anything if this is true (debug/testing only).
if [[ "$ZSH_NVM_NO_LOAD" != true ]]; then

  # Install nvm if it isn't already installed
  [[ ! -f "$NVM_DIR/nvm.sh" ]] && _zsh_nvm_x_install

  # If nvm is installed
  if [[ -f "$NVM_DIR/nvm.sh" ]]; then

    # Load it
    [[ "$NVM_LAZY_LOAD" == true ]] && _zsh_nvm_x_lazy_load || _zsh_nvm_x_load

    # Enable completion
    [[ "$NVM_COMPLETION" == true ]] && _zsh_nvm_x_completion
    
    # Auto-use .nvmrc on directory changes
    [[ "$NVM_AUTO_USE" == true ]] && _zsh_nvm_x_enable_auto_use
  fi

fi

# Make sure we always return good exit code
# We can't `return 0` because that breaks antigen
true
