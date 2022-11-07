all: docs lint test 

docs:
	@echo "=== Generating docs ==="
	make -C components docs
	make -C modules docs

test:
	@echo "=== Testing components ==="
	make -C components test
	@echo "=== Testing modules ==="
	make -C modules test

lint:
	@echo "=== Linting ==="
	terraform fmt -check -recursive .

.PHONY: all test docs lint
