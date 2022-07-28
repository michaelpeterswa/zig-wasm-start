# -=-=-=-=-=-=- Compile Zig WASM Binary -=-=-=-=-=-=-

FROM alpine:edge as zig-build

WORKDIR /build

COPY . .

RUN apk add --no-cache zig=0.9.1-r0 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    zig build-lib src/add.zig -target wasm32-freestanding -dynamic -O ReleaseSmall

# -=-=-=-=-=-=- Setup Apache HTTPD -=-=-=-=-=-=-

FROM httpd:2.4 as web-server

COPY --from=zig-build build/add.wasm /usr/local/apache2/htdocs/add.wasm
COPY ./frontend/ /usr/local/apache2/htdocs/

RUN echo "AddType application/wasm .wasm" >> /usr/local/apache2/conf/httpd.conf