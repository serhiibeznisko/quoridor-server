# Containers ids
django-id=$(shell docker ps -a -q -f "name=corridor-django")

# Build docker containers
build: build-django
build-django:
	@docker-compose -f docker-compose.yml build corridor-django

# Stop docker containers
stop-all:
	@docker-compose stop
stop-django:
	-@docker stop $(django-id)


# Remove docker containers
rm-all: rm-django
rm-django:
	-@docker rm $(django-id)

# Remove, build and run docker containers
rm-build: stop-all rm-all build run
rm-build-django: stop-django rm-django build-django

# Run docker containers
run:
	@docker-compose -f docker-compose.yml up

run-django:
	@docker-compose -f docker-compose.yml up corridor-django


# Go to container bash shell
shell-django:
	@docker exec -it corridor-django ash


# Django commands
manage:
	@docker exec -t corridor-django python src/manage.py $(cmd)

migrate:
	@docker exec -t corridor-django python src/manage.py migrate

migrations:
	@docker exec -it corridor-django python src/manage.py makemigrations

# Tests
test:
	@docker exec -t corridor-django /bin/sh -c "cd src && PYTHONDONTWRITEBYTECODE=1 python -m pytest $(dir) --disable-warnings"
