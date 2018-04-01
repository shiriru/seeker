PROJECT_NAME = seeker
SHELL := /bin/sh
help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "virtualenv                   Create virtual enviroment"
	@echo "requirements                 Install requirements.txt"
	@echo "migrate 						Run Django migrations"
	@echo "user  						Create user account"
	@echo "test  						Run tests"
	@echo "clean 						Remove all *.pyc, .DS_Store and temp files from the project"
	@echo "shell 						Open Django shell"
	@echo "migrations 					Create database migrations"
	@echo "collectstatic 				Collect static assets"
	@echo "run 							Run Django Server"

.PHONY: requirements


# Command variables
MANAGE_CMD = python manage.py
PIP_INSTALL_CMD = pip install
PLAYBOOK = ansible-playbook
VIRTUALENV_NAME = venv

# Helper functions to display messagse
ECHO_BLUE = @echo "\033[33;34m $1\033[0m"
ECHO_RED = @echo "\033[33;31m $1\033[0m"
ECHO_GREEN = @echo "\033[33;32m $1\033[0m"

# The default server host local development
HOST ?= localhost:8000


virtualenv:
# Create virtualenv
	virtualenv -p python3 $(VIRTUALENV_NAME)

requirements:
# Install project requirements
	( \
		source venv/bin/activate;\
		$(PIP_INSTALL_CMD) -r requirements.txt; \
	)

migrate:
# Run django migrations
	( \
		cd seeker; \
		$(MANAGE_CMD) migrate; \
	)

user:
# Create user account
	( \
		cd seeker; \
		echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@email.com', 'pass')" | ./manage.py shell; \
	)

test:
# Run the test cases
	( \
		cd seeker; \
		$(MANAGE_CMD) test; \
	)

clean:
# Remove all *.pyc, .DS_Store and temp files from the project
	$(call ECHO_BLUE,removing .pyc files...)
	@find . -name '*.pyc' -exec rm -f {} \;
	$(call ECHO_BLUE,removing static files...)
	@rm -rf $(PROJECT_NAME)/_static/
	$(call ECHO_BLUE,removing temp files...)
	@rm -rf $(PROJECT_NAME)/_tmp/
	$(call ECHO_BLUE,removing .DS_Store files...)
	@find . -name '.DS_Store' -exec rm {} \;

shell:
# Run a local shell for debugging
	( \
		cd seeker; \
		$(MANAGE_CMD) shell; \
	)

migrations:
# Create database migrations
	( \
		cd seeker; \
		$(MANAGE_CMD) makemigrations; \
	)

migrate:
# Run database migrations
	( \
		cd seeker; \
		$(MANAGE_CMD) migrate; \
	)

collectstatic:
# Collect static assets
	( \
		cd seeker; \
		$(MANAGE_CMD) collectstatic; \
	)

run:
# run django server
	$(call ECHO_GREEN, Starting Django Server...)
	( \
		cd seeker; \
		$(MANAGE_CMD) runserver; \
	)

