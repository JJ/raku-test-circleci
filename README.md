# A docker container to test Raku applications in CircleCI [![Build Status](https://travis-ci.org/JJ/raku-test-circleci.svg?branch=master)](https://travis-ci.org/JJ/raku-test-circleci)

`jjmerelo/raku-test-circleci` is a a Docker container with Raku for testing
and continuous integration, mainly for use in Travis and other CI
environments. This image should be automatically built and available
at the [Docker Hub](https://hub.docker.com/r/jjmerelo/raku-test-circleci/). It
depends on the [Alpine Raku image](https://hub.docker.com/r/jjmerelo/alpine-perl6/), which is a
Raku interpreter based on the lightweight Alpine distribution. This version is exactly the same as `jjmerelo/raku-test` except it also includes `ssh`.

This Dockerfile
is [hosted in GitHub](https://github.com/JJ/raku-test-circleci). It will be
automatically rebuilt every time a new version of the `raku-test`
image is pushed. Please raise an issue if there's any problem with it.

## Local use

After the usual `docker pull jjmerelo/raku-test-circleci` type

    docker run -t -v /path/to/module-dir:/test jjmerelo/raku-test-circleci 

The local `module-dir` gets mapped to the container's `/test` directory,
and tests are run using the usual `prove` or whatever method is
available to `zef` after installing
dependencies. 

You can also do:

    docker run -t -v  $PWD:/test jjmerelo/raku-test-circleci

(Use `sudo` in front of `docker` if your local setup needs it).

## Use in CircleCI

Add something like this to your config.yml file within the .circleci directory:

```
version: 2
jobs:
  test-linux:
    docker:
      - image: jjmerelo/raku-test-circleci
    steps:
      - checkout
      - run:
          name: Test Documentable
          command: |
            zef update
            zef install .
```

In general, the container will install all Raku dependencies for you, but you
might want to do it separately to check for failing dependencies, for
instance.

If you need to install non-Raku dependencies, remember that you are
going to be using [Alpine Linux](https://alpinelinux.org/) underneath
in this container. For instance, many modules use `openssl-dev`. In
that case, you'll have to use this as the testing script:

    script:  docker run -t  --entrypoint="/bin/sh" \
      -v  $TRAVIS_BUILD_DIR:/test \jjmerelo/raku-test-circleci\
      -c "apk add --update --no-cache openssl-dev make \
      build-base && zef install --deps-only . && zef test ."

to the `script:` section of Travis.

In other, more complicated cases, you might need to build from source,
but at any rate you can try and look for the name of the package in
Alpine. Pretty much everything is in
there. Use [the package search site](https://pkgs.alpinelinux.org/) to
look for the name of the package that is included in your dependencies.

Underneath, zef uses `prove6` or any other testing framework that is
available. You can use it directly if you don't have a `META6.json` file.

    script:  docker run -t  --entrypoint="/bin/sh" \
      -v  $TRAVIS_BUILD_DIR:/test \jjmerelo/raku-test-circleci\
      -c "prove6 --lib"

(if there are no dependencies involved)

## See also

[The `raku-test-openssl` container](https://cloud.docker.com/u/jjmerelo/repository/docker/jjmerelo/raku-test-openssl),
which already includes OpenSSL, one of the most depended-upon modules
in the Raku ecosystem. Use that one if it's in one of your
dependencies.
