FROM alpine:edge as zig-build

COPY . .

RUN apk add --no-cache zig --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    zig build-lib src/add.zig -target wasm32-freestanding -dynamic -O ReleaseSmall

FROM httpd:2.4 as web-server

COPY --from=zig-build add.wasm /usr/local/apache2/htdocs/add.wasm
COPY ./frontend/ /usr/local/apache2/htdocs/

RUN echo "AddType application/wasm .wasm" >> /usr/local/apache2/conf/httpd.conf