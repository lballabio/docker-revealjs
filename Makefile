.PHONY: build shell

build:
	@docker build --rm -t lballabio/revealjs:onbuild .

shell:
	@docker run -it --rm \
		-p 8000:8000 \
		lballabio/revealjs:onbuild \
		/bin/bash
