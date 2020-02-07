FROM alpine:latest

ARG JOSEF-VERSION=0.1.1

RUN apk add --update --no-cache \
    perl \
    perl-template-toolkit \
    unzip \
    git

RUN mkdir -p /kadoc
WORKDIR /kadoc

COPY git clone https://github.com/afeldman/Josef.git /kadoc
RUN perl Makefile.PL \
    && make \
    && make install 

ENTRYPOINT ["kadoc.pl"]
