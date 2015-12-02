#
# Simon Lefort
# SaltStack Makefile

# Name of the Container you're going to build/run
NAME:=app-salt
CDFACTORY:="/app/cd-factory/"

# We can specify the running mode to use (interactive or detached)
# available options:
# 	interactive mode=i (default)
# 	detached mode=d
# example: make mode=d run 
ifndef mode
	mode=d
 	endif

# We can specify the data docker port to bind (default is same as the app (80 or 53 most of the time)
# example: make data_port=8010 run
ifndef data_port
       data_port=80
endif

# We can specify the internal data docker port to bind (default is same as the app)
# example: make data_port=8010 run
ifndef internal_data_port
	internal_data_port=8080
endif

RUNNING:=$(shell docker ps | grep $(NAME) | cut -f 1 -d ' ')
ALL:=$(shell docker ps -a | grep $(NAME) | cut -f 1 -d ' ')
DOCKER_RUN_COMMON=--name="$(NAME)" --privileged=true -p $(internal_data_port):8080/tcp -p $(data_port):80/tcp -v "$(CDFACTORY)":"/app/cd-factory/" -t $(NAME)

# Build the Container
all: build
build: clean
	docker build -t=$(NAME) .

# Run the container
run: clean
	docker run -$(mode) $(DOCKER_RUN_COMMON)

# Exec in the container
exec:
	docker exec -ti $(NAME) bash -l

# Salt-Call in the container
salt-call: 
	docker exec -it $(NAME) salt-call --local state.sls $(role)

# Removes existing containers.
clean:
ifneq ($(strip $(RUNNING)),)
	docker stop $(RUNNING)
endif
ifneq ($(strip $(ALL)),)
	docker rm $(ALL)
endif

# Destroys the data directory.
deepclean: clean
