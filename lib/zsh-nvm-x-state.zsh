[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Internal mutable state
typeset -g _ZSH_NVM_X_CACHED_DEFAULT_VERSION
typeset -g _ZSH_NVM_X_AUTO_USE_ACTIVE=false
typeset -g _ZSH_NVM_X_AUTO_USE_HOOK_SET=false
typeset -g _ZSH_NVM_X_LAZY_INITIALIZED=false
typeset -ga _ZSH_NVM_X_LAZY_CMDS=()
