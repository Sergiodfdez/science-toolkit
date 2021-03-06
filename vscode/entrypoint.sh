#!/bin/sh

DEFAULT_SETTINGS_FILE="/config/default_user_settings.json"
USER_SETTINGS_DIR="$HOME/.local/share/code-server/User"
SETTINGS_FILE="${USER_SETTINGS_DIR}/settings.json"
TMP_FILE=$(mktemp)

if [ ! -d ${USER_SETTINGS_DIR} ]; then
  mkdir -p ${USER_SETTINGS_DIR}
fi

if [ ! -f ${SETTINGS_FILE} ]; then
  echo "{}" > ${SETTINGS_FILE}
fi

# Update gopls users settings to true
jq -s '.[1] * .[0]' ${DEFAULT_SETTINGS_FILE} ${SETTINGS_FILE} > ${TMP_FILE} \
      && mv ${TMP_FILE} ${SETTINGS_FILE}

dumb-init code-server \
  --auth none --host 0.0.0.0 \
  --disable-ssh --disable-updates --disable-telemetry \
  --extensions-dir /extensions \
  /home/coder
