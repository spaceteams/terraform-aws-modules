all: lint test

test:
	@echo "=== Testing components ==="
	make -C components test
	@echo "=== Testing modules ==="
	make -C modules test

lint:
	@echo "=== Linting ==="
	terraform fmt -check -recursive .

.PHONY: all test lint
