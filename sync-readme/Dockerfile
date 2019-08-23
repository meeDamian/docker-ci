FROM alpine:3.10

RUN apk update && apk add curl

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
