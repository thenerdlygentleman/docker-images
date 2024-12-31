# Docker Images

## Summary

Variation of docker images, that can be used for CI or as development
environments.

## Building

The Docker images are build and published to **Dockerhub** via
[Github action](./.github/workflows/).

### DEV

Whenever there is a commit pushed to one of the image directories a images with
the tag **dev** is published to **Dockerhub**.

The **Gitlab** action files are identified with `*_dev.yaml`.

This images are for testing purposes only and should not be used in production.

### PROD

The **Gitlab** action for the production version of the image are not triggered
automatically.
A collaborator has to start the CI manually, by adding the desired tag name of
the image.

## Images

|**Name**        |**Version**|**Path**                                      |**Dockerhub**                                                                               |
|----------------|:---------:|----------------------------------------------|--------------------------------------------------------------------------------------------|
|*mdbook*        |`0.1.0`    |[./mdbook](./mdbook/README.md)                |[mdbook](https://hub.docker.com/repository/docker/thenerdlygentleman/mdbook)                |
|*playground*    |`0.2.0`    |[./playground](./playground/README.md)        |[playground](https://hub.docker.com/repository/docker/thenerdlygentleman/playground)        |
|*robotframework*|`0.1.0`    |[./robotframework](./robotframework/README.md)|[robotframework](https://hub.docker.com/repository/docker/thenerdlygentleman/robotframework)|
