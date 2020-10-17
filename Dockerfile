FROM jjmerelo/raku-test:latest
LABEL version="2.0" maintainer="JJ Merelo <jjmerelo@GMail.com>"

USER root
RUN apk add --upgrade openssh-client

USER raku
RUN zef install License::SPDX


# Will run this
ENTRYPOINT raku -v && zef install --deps-only . && zef test .


