all: docs test

docs:
	terraform-docs -c ../../.terraform-docs.yml --output-file README.md .

test:
	make -C test test

.PHONY: all test docs
