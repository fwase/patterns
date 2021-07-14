# Lint recipes
.PHONY: black
black:
	pipenv run black **/ --exclude snapshots $(BLACK_OPTIONS)

.PHONY: isort
isort:
	pipenv run isort **/ --multi-line 3 --trailing-comma --line-width 88 --skip snapshots $(ISORT_OPTIONS)

.PHONY: autoflake
autoflake:
	pipenv run autoflake -r $(AUTOFLAKE_OPTIONS) --exclude snapshots --remove-unused-variables --remove-all-unused-imports  **/ | tee autoflake.log
	echo "$(AUTOFLAKE_OPTIONS)" | grep -q -- '--in-place' || ! [ -s autoflake.log ]

.PHONY: lint
lint: ISORT_OPTIONS := --check-only
lint: BLACK_OPTIONS := --check
lint: autoflake isort black
	pipenv run mypy **/*.py --ignore-missing-imports
	pipenv run flake8 **/*.py --exclude snapshots

.PHONY: format
format: AUTOFLAKE_OPTIONS := --in-place
format: autoflake isort black