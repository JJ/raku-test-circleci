FROM jjmerelo/test-perl6:latest
LABEL version="1.0" maintainer="JJ Merelo <jjmerelo@GMail.com>"

RUN apk add --upgrade openssh-client \
    && zef install License::SPDX


# Will run this
ENTRYPOINT perl6 -v && zef install --deps-only . && zef test .


