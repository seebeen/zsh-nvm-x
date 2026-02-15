#!/usr/bin/env zsh

Describe 'core helpers'
  setup() {
    export NVM_DIR="$SHELLSPEC_TMPBASE/nvm"
    mkdir -p "$NVM_DIR"
    unset _ZSH_NVM_X_CACHED_DEFAULT_VERSION
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-state.zsh"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-core.zsh"
  }

  BeforeEach 'setup'

  It '_zsh_nvm_x_has returns success when command exists'
    foo_dir="$SHELLSPEC_TMPBASE/bin"
    mkdir -p "$foo_dir"
    cat > "$foo_dir/foo-cmd" <<'SCRIPT'
#!/usr/bin/env sh
exit 0
SCRIPT
    chmod +x "$foo_dir/foo-cmd"
    PATH="$foo_dir:$PATH"

    When call _zsh_nvm_x_has foo-cmd
    The status should be success
  End

  It '_zsh_nvm_x_has returns failure when command is missing'
    When call _zsh_nvm_x_has definitely-missing-cmd
    The status should be failure
  End

  It '_zsh_nvm_x_default_version returns discovered default version'
    nvm() {
      echo 'v18.20.0'
    }

    When call _zsh_nvm_x_default_version
    The output should equal 'v18.20.0'
  End

  It '_zsh_nvm_x_default_version honors cached value'
    nvm() {
      echo 'v20.11.1'
    }
    _ZSH_NVM_X_CACHED_DEFAULT_VERSION='v18.20.0'

    When call _zsh_nvm_x_default_version
    The output should equal 'v18.20.0'
  End

  It '_zsh_nvm_x_global_binaries outputs deduplicated binaries'
    mkdir -p "$NVM_DIR/v0.39.0/bin"
    mkdir -p "$NVM_DIR/versions/node/v20.0.0/bin"
    : > "$NVM_DIR/v0.39.0/bin/node"
    : > "$NVM_DIR/versions/node/v20.0.0/bin/node"
    : > "$NVM_DIR/versions/node/v20.0.0/bin/npm"

    When call _zsh_nvm_x_global_binaries
    The output should equal "$(printf 'node\nnpm')"
  End
End
