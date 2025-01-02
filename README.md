# Docker Images

## Summary

Variation of docker images, that can be used for CI or as development
environments.

## Building

### Local

Build and run the containers locally from
[docker-compose](./docker-compose.yaml) with

```shell
docker compose run --rm --build <container-name>
# For debugging
docker compose --progress plain run --rm --build <container-name>
```

### GitHub

The Docker images are build and published to **Dockerhub** via
[Github action](./.github/workflows/).

#### DEV

Whenever there is a commit pushed to one of the image directories a images with
the tag **dev** is published to **Dockerhub**.

The **Gitlab** action files are identified with `*_dev.yaml`.

This images are for testing purposes only and should not be used in production.

#### PROD

The **Gitlab** action for the production version of the image are not triggered
automatically.
A collaborator has to start the CI manually, by adding the desired tag name of
the image.

## Test

If the **Dockerfile** has a test stage you can directly run it with

```shell
# the stage must be named `test` for this to work
docker build --target test <path/to/image>
```

## Images

|**Name**        |**Version**|**Path**                                      |**Dockerhub**                                                                               |
|----------------|:---------:|----------------------------------------------|--------------------------------------------------------------------------------------------|
|*mdbook*        |`0.2.0`    |[./mdbook](./mdbook/README.md)                |[mdbook](https://hub.docker.com/repository/docker/thenerdlygentleman/mdbook)                |
|*playground*    |`0.4.0`    |[./playground](./playground/README.md)        |[playground](https://hub.docker.com/repository/docker/thenerdlygentleman/playground)        |
|*robotframework*|`0.2.0`    |[./robotframework](./robotframework/README.md)|[robotframework](https://hub.docker.com/repository/docker/thenerdlygentleman/robotframework)|
