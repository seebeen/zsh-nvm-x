_zsh_nvm_x_trigger_lazy_load() {
  local cmd="$1"
  shift

  unset -f -- "${_ZSH_NVM_X_LAZY_CMDS[@]}" > /dev/null 2>&1
  _ZSH_NVM_X_LAZY_INITIALIZED=false
  _zsh_nvm_x_load
  "$cmd" "$@"
}

_zsh_nvm_x_lazy_load() {
  # Avoid re-registering lazy wrappers if the plugin is sourced more than once.
  [[ "$_ZSH_NVM_X_LAZY_INITIALIZED" == true ]] && return

  # Get all global node module binaries including node
  # (only if NVM_NO_USE is off)
  local -a global_binaries
  if [[ "$NVM_NO_USE" == true ]]; then
    global_binaries=()
  else
    global_binaries=("${(@f)$(_zsh_nvm_x_global_binaries)}")
  fi

  # Add yarn lazy loader if it's been installed by something other than npm
  _zsh_nvm_x_has yarn && global_binaries+=('yarn')

  # Add nvm
  global_binaries+=('nvm')
  global_binaries+=("${NVM_LAZY_LOAD_EXTRA_COMMANDS[@]}")

  # Remove any binaries that conflict with current aliases
  local -a cmds
  cmds=()
  local bin
  for bin in "${global_binaries[@]}"; do
    [[ -z "$bin" ]] && continue
    (( ${+aliases[$bin]} )) || cmds+=("$bin")
  done

  # Deduplicate command list while preserving order.
  typeset -U cmds
  _ZSH_NVM_X_LAZY_CMDS=("${cmds[@]}")

  # Create function for each command
  local cmd
  for cmd in "${cmds[@]}"; do

    # When called, unset all lazy loaders, load nvm then run current command
    eval "${cmd}(){
      _zsh_nvm_x_trigger_lazy_load '${cmd}' \"\$@\"
    }"
  done

  _ZSH_NVM_X_LAZY_INITIALIZED=true
}
