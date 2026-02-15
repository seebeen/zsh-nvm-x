#!/usr/bin/env zsh

Describe 'wrapper commands'
  setup() {
    export NVM_DIR="$SHELLSPEC_TMPBASE/nvm"
    export ZSH_NVM_DIR="$SHELLSPEC_TMPBASE/plugin"
    mkdir -p "$NVM_DIR" "$ZSH_NVM_DIR"
    source "$SHELLSPEC_PROJECT_ROOT/lib/zsh-nvm-x-wrappers.zsh"
  }

  BeforeEach 'setup'

  It 'nvm_update prints deprecation notice'
    When call nvm_update
    The output should equal 'Deprecated, please use `nvm upgrade`'
  End

  It 'revert reports when no previous version exists'
    When call _zsh_nvm_x_revert
    The output should equal 'No previous version found'
  End

  It 'install rc uses rc mirror and aliases rc'
    bindir="$SHELLSPEC_TMPBASE/bin"
    mkdir -p "$bindir"
    cat > "$bindir/node" <<'SCRIPT'
#!/usr/bin/env sh
echo v22.0.0-rc.1
SCRIPT
    chmod +x "$bindir/node"
    PATH="$bindir:$PATH"

    nvm() {
      echo "mirror=${NVM_NODEJS_ORG_MIRROR};cmd=$*"
    }

    When call _zsh_nvm_x_install_wrapper install rc
    The output should include 'mirror=https://nodejs.org/download/rc/;cmd=install node'
    The output should include 'mirror=;cmd=alias rc v22.0.0-rc.1'
    The output should include 'Done!'
  End
End
