#!/usr/bin/env zsh

Describe 'plugin bootstrap'
  setup() {
    export __ROOT="$SHELLSPEC_PROJECT_ROOT"
    export NVM_DIR="$SHELLSPEC_TMPBASE/nvm"
    mkdir -p "$NVM_DIR"
  }

  BeforeEach 'setup'

  It 'respects ZSH_NVM_NO_LOAD=true'
    When run zsh -fc '
      export ZSH_NVM_NO_LOAD=true
      export NVM_DIR="'$SHELLSPEC_TMPBASE'/noload"
      source "'$SHELLSPEC_PROJECT_ROOT'/zsh-nvm-x.plugin.zsh"
      echo "loaded:$?"
    '
    The status should be success
    The output should include 'loaded:0'
  End

  It 'returns success even when nvm is not installed and load is disabled'
    When run zsh -fc '
      export ZSH_NVM_NO_LOAD=true
      export NVM_DIR="'$SHELLSPEC_TMPBASE'/no-nvm"
      source "'$SHELLSPEC_PROJECT_ROOT'/zsh-nvm-x.plugin.zsh"
    '
    The status should be success
  End
End
