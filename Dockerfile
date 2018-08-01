FROM alpine:latest

ARG JOSEF-VERSION=0.0.1

RUN apk add --update --no-cache \
    perl \
    perl-template-toolkit \
    unzip

RUN mkdir -p /kadoc
WORKDIR /kadoc

COPY ./release/josef-$JOSEF-VERSION.zip /kadoc
RUN unzip /kadoc/josef.zip \
    && perl Makefile.PL \
    && make \
    && make install

ENTRYPOINT ["/kadoc/bin/kadoc.pl"]
