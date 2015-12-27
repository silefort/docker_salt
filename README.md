# docker_salt

This starter kit builds and runs a docker container and exec salt-call within it
In the example provided the salt job will install and run nginx within the container

## Prepare

In this example, you need to have your salt-pillars and salt-states in a cd-factory folder at /app/cd-factory
If your cd-factory directory is somewhere else, you can edit the value of CDFACTORY in Makefile

Create docker/minion.conf and docker/grains (.sample files are provided, you can just rename them)

## Build the container

```bash
make
```

## Run the container

```bash
make run
```

## install and run nginx with the container

```bash
make salt-call role=nginx
```

## Test your container

```bash
curl http://localhost
```

