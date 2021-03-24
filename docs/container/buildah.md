Installing and using Buildah for rootless container builds
==========================================================

Buildah is a tool for building OCI container images which supports building containers as an unprivileged user.
This is useful for environments such as HPC clusters, which typically don't provide users access to the Docker daemon.

To install Buildah:

```
$ ansible-playbook playbooks/container/buildah.yml
```

After installing Buildah, you can build a container image from a Dockerfile as a regular user.

First, create a Dockerfile for the container image you want to build. For example:

```
FROM docker.io/ubuntu:18.04
RUN apt-get update
RUN apt-get install -y fortune
CMD /usr/games/fortune
```

Then build the container using Buildah:

```
$ buildah bud -t <container-name> .
```

Where `container-name` is the image name and tag for the image being built, e.g. `docker.io/ajdecon/fortune:latest`.

You can then list images in your Buildah image list:

```
$ buildah images
REPOSITORY                  TAG      IMAGE ID       CREATED          SIZE
docker.io/ajdecon/fortune   latest   c9c8e89293a8   11 minutes ago   104 MB
docker.io/library/ubuntu    18.04    329ed837d508   2 weeks ago      65.6 MB
```

The image can then be pushed to an external registry:

```
$ buildah push --creds ajdecon:<password> c9c8e89293a8 docker://docker.io/ajdecon/fortune:latest
```

And then run from any other container runtime, such as Docker:

```
$ docker run ajdecon/fortune:latest
Unable to find image 'ajdecon/fortune:latest' locally
latest: Pulling from ajdecon/fortune
92dc2a97ff99: Already exists
be13a9d27eb8: Already exists
c8299583700a: Already exists
968572b99123: Pull complete
Digest: sha256:1fb1b6dd2ac26c0ec0e62a73e9efd6947da0e88dc324f61455cde0ece691da9d
Status: Downloaded newer image for ajdecon/fortune:latest
You learn to write as if to someone else because NEXT YEAR YOU WILL BE
"SOMEONE ELSE."
```
