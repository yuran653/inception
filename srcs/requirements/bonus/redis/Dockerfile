FROM alpine:3.19

RUN apk update && apk upgrade && \
    apk add --no-cache redis && \
    sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g"  /etc/redis.conf && \
    sed -i "s|# maxmemory <bytes>|maxmemory 20mb|g"  /etc/redis.conf && \
    echo "maxmemory-policy allkeys-lru" >> /etc/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server"]

CMD ["/etc/redis.conf", "--protected-mode no"]
