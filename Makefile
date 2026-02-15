.PHONY: lint-shell test test-unit test-smoke

lint-shell:
	zsh -n zsh-nvm-x.plugin.zsh lib/*.zsh spec/*.sh

test-unit:
	shellspec

test-smoke:
	bash test/smoke/startup_smoke.sh
	bash test/smoke/lazy_load_smoke.sh

test: lint-shell test-unit test-smoke
