FROM frolvlad/alpine-glibc:alpine-3.3_glibc-2.23

WORKDIR /opt

COPY ./new_smart_launch.sh /opt

VOLUME /opt/factorio/saves /opt/factorio/mods /opt/factorio/scenarios

ENV FACTORIO_AUTOSAVE_INTERVAL=2 \
    FACTORIO_AUTOSAVE_SLOTS=3 \
    FACTORIO_ALLOW_COMMANDS=false \
    FACTORIO_NO_AUTO_PAUSE=false \
    FACTORIO_WAITING=false \
    FACTORIO_SCENARIO="" \
    FACTORIO_MODE=normal

ENV MAP_WIDTH=0 \
    MAP_HEIGHT=0

EXPOSE 34197/udp 27015/tcp

ENV SERVER_NAME="factorio server" \
    SERVER_DESCRIPTION="" \
    SERVER_VISIBILITY="hidden" \
    SERVER_GAME_PASSWORD="" \
    SERVER_VERIFY_IDENTITY="true" \
    SERVER_USERNAME="" \
    SERVER_PASSWORD=""

CMD ["./new_smart_launch.sh"]

ARG VERSION=0.14.5

ADD https://www.factorio.com/get-download/$VERSION/headless/linux64 /tmp/factorio_headless_x64_$VERSION.tar.gz
RUN tar xzf /tmp/factorio_headless_x64_$VERSION.tar.gz && \
    rm /tmp/factorio_headless_x64_$VERSION.tar.gz
