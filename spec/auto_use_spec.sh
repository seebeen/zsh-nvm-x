#!/usr/bin/env zsh

Describe 'auto-use behavior'
  setup() {
    export NVM_DIR="$SHELLSPEC_TMPBASE/nvm"
    mkdir -p "$NVM_DIR"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-state.zsh"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-core.zsh"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-auto-use.zsh"
  }

  BeforeEach 'setup'

  It 'registers chpwd hook only once'
    __HOOK_CALLS=0
    add-zsh-hook() {
      __HOOK_CALLS=$((__HOOK_CALLS + 1))
    }
    _zsh_nvm_x_auto_use() { :; }

    _zsh_nvm_x_enable_auto_use
    _zsh_nvm_x_enable_auto_use

    When call echo "${_ZSH_NVM_X_AUTO_USE_HOOK_SET}|${__HOOK_CALLS}"
    The output should equal 'true|1'
  End

  It 'runs nvm install when .nvmrc version is not installed'
    nvm_find_nvmrc() {
      echo "$SHELLSPEC_TMPBASE/project/.nvmrc"
    }
    mkdir -p "$SHELLSPEC_TMPBASE/project"
    echo 'v22.0.0' > "$SHELLSPEC_TMPBASE/project/.nvmrc"

    nvm() {
      case "$1" in
        version)
          if [[ -n "$2" ]]; then
            echo 'N/A'
          else
            echo 'v18.20.0'
          fi
          ;;
        install)
          echo 'installed'
          ;;
      esac
    }

    When call _zsh_nvm_x_auto_use
    The output should include 'installed'
    The variable _ZSH_NVM_X_AUTO_USE_ACTIVE should equal 'true'
  End

  It 'reverts to default when leaving nvmrc tree'
    nvm_find_nvmrc() { :; }
    _ZSH_NVM_X_AUTO_USE_ACTIVE=true
    _zsh_nvm_x_default_version() { echo 'v18.20.0'; }
    nvm() {
      case "$1" in
        version) echo 'v20.11.1' ;;
        use) echo "use:$2" ;;
      esac
    }

    When call _zsh_nvm_x_auto_use
    The output should include 'Reverting to nvm default version'
    The output should include 'use:default'
    The variable _ZSH_NVM_X_AUTO_USE_ACTIVE should equal 'false'
  End
End
