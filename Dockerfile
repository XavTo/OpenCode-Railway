FROM ghcr.io/anomalyco/opencode:1.19.2@sha256:37d71f37e3f4a7695f70f63a79f02ff2e5242e5c7e26c88f6fe510e9038fd5ca AS opencode
FROM caddy:2.11.7-alpine@sha256:d8542f48d34a9cf4e4c11a478865229840e87e4c96ea3f439101f31a5d35f75f

RUN apk add --no-cache bash ca-certificates curl git libgcc libstdc++ nodejs npm openssh-client python3 ripgrep tini \
    && addgroup -g 1000 opencode \
    && adduser -D -u 1000 -G opencode -h /data/home opencode
COPY --from=opencode /usr/local/bin/opencode /usr/local/bin/opencode
COPY entrypoint.py /opt/railway/entrypoint.py
ENV PORT=8080 HOME=/data/home \
    XDG_DATA_HOME=/data/xdg/data XDG_CONFIG_HOME=/data/xdg/config \
    XDG_STATE_HOME=/data/xdg/state XDG_CACHE_HOME=/data/xdg/cache \
    OPENCODE_SERVER_USERNAME=opencode OPENCODE_DISABLE_AUTOUPDATE=true \
    BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
WORKDIR /data/workspace
EXPOSE 8080
ENTRYPOINT ["/sbin/tini", "-g", "--", "python3", "-u", "/opt/railway/entrypoint.py"]
