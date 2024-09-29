# Docker Images

## Push to [Dockerhub](https://hub.docker.com/repositories/thenerdlygentleman)

1. Create the repository on
[Dockerhub](https://hub.docker.com/repositories/thenerdlygentleman).
2. Tag the created image locally

   ```shell
   docker image tag <image>:<tag> thenerdlygentleman/<image>:<tag>
   ```
3. Push the image.

   ```shell
   docker push thenerdlygentleman/<image>:<tag>
   ```
