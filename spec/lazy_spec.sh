#!/usr/bin/env zsh

Describe 'lazy loading'
  setup() {
    export NVM_DIR="$SHELLSPEC_TMPBASE/nvm"
    mkdir -p "$NVM_DIR"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-state.zsh"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-core.zsh"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-lazy.zsh"
  }

  BeforeEach 'setup'

  It 'registers lazy commands once'
    _zsh_nvm_x_global_binaries() {
      printf 'node\nnpm\n'
    }

    _zsh_nvm_x_lazy_load
    first_count="${#_ZSH_NVM_X_LAZY_CMDS[@]}"
    _zsh_nvm_x_lazy_load
    second_count="${#_ZSH_NVM_X_LAZY_CMDS[@]}"

    When call echo "${_ZSH_NVM_X_LAZY_INITIALIZED}|${first_count}|${second_count}"
    The output should equal 'true|3|3'
  End

  It 'skips commands that are currently aliased'
    _zsh_nvm_x_global_binaries() {
      printf 'node\nnpm\n'
    }
    alias npm='echo nope'

    _zsh_nvm_x_lazy_load

    When call echo "${(j: :)_ZSH_NVM_X_LAZY_CMDS}"
    The output should equal 'node nvm'
  End

  It 'trigger loads nvm and forwards arguments'
    _ZSH_NVM_X_LAZY_CMDS=(foo)
    _zsh_nvm_x_load() {
      foo() {
        echo "ran:$*"
      }
    }

    When call _zsh_nvm_x_trigger_lazy_load foo hello world
    The output should equal 'ran:hello world'
    The variable _ZSH_NVM_X_LAZY_INITIALIZED should equal 'false'
  End
End
