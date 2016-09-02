#!/bin/sh

# write server settings
SERVER_SETTINGS=/opt/factorio/server-settings.json
cat << EOF > $SERVER_SETTINGS
{
  "name": "$SERVER_NAME",
  "description": "$SERVER_DESCRIPTION",
  "max_players": "$SERVER_MAX_PLAYERS",

  "_comment_visibility": ["public: Game will be published on the official Factorio matching server",
                          "lan: Game will be broadcast on LAN",
                          "hidden: Game will not be published anywhere"],
  "visibility": "$SERVER_VISIBILITY",

  "_comment_credentials": "Your factorio.com login credentials. Required for games with visibility public",
  "username": "",
  "password": "",

  "_comment_token": "Authentication token. May be used instead of 'password' above.",
  "token": "",

  "game_password": "$SERVER_GAME_PASSWORD",

  "_comment_verify_user_identity": "When set to true, the server will only allow clients that have a valid Factorio.com account",
  "verify_user_identity": $SERVER_VERIFY_IDENTITY
}
EOF


# Setting initial command
mode=""
case "$FACTORIO_MODE" in
    heavy)
        mode="--heavy"
        ;;
    complete)
        mode="--complete"
        ;;
esac


# Setting auto-pause option
noautopause=""
[ "$FACTORIO_NO_AUTO_PAUSE" = true ] && noautopause="--no-auto-pause"

# Setting rcon password option
if [ -z $FACTORIO_RCON_PASSWORD ]; then
  FACTORIO_RCON_PASSWORD=$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c16)
  echo "###"
  echo "# RCON password is '$FACTORIO_RCON_PASSWORD'"
  echo "###"
fi

# Handling save settings
save_dir="/opt/factorio/saves"

cd $save_dir

if [ "$(ls -A $save_dir)" ]; then
  echo "Taking latest save"
else
  echo "# Creating a new map [save.zip]"
  /opt/factorio/bin/x64/factorio --create save.zip
fi

# Closing stdin
exec 0<&-
exec /opt/factorio/bin/x64/factorio \
    $mode \
    $noautopause \
    --rcon-password $FACTORIO_RCON_PASSWORD \
    --start-server-load-latest \
    --server-settings $SERVER_SETTINGS \
    --allow-commands $FACTORIO_ALLOW_COMMANDS \
    --autosave-interval $FACTORIO_AUTOSAVE_INTERVAL \
    --autosave-slots $FACTORIO_AUTOSAVE_SLOTS\
    --rcon-port 27015
