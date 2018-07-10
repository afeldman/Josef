FROM alpine:latest

RUN apk add --update --no-cache perl
#&& rm -rf /var/cache/apk/*

COPY ./kadoc.pl /usr/bin/kadoc
RUN chmod 111 /usr/bin/kadoc

ENTRYPOINT ["/usr/bin/kadoc"]