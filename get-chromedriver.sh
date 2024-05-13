#!/usr/bin/env bash

TARGET_DIR=${1:-./build}
CHROMEDRIVER_VERSION=${2:-118.0.5993.70}

rm -rf "${TARGET_DIR}/.tmp/"
mkdir -p "${TARGET_DIR}/.tmp/"

#
# Try download from testing-public storage
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  curl -O -L https://storage.googleapis.com/chrome-for-testing-public/"${CHROMEDRIVER_VERSION}"/linux64/chrome-linux64.zip
  if ! unzip -t chrome-linux64.zip >/dev/null; then
    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in storage (for-testing-public)"
    exit 0
  fi

  unzip -o ./chromedriver_linux64.zip -d "${TARGET_DIR}/.tmp/"
fi

#
# Try download from storage
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  curl -O -L http://chromedriver.storage.googleapis.com/"${CHROMEDRIVER_VERSION}"/chromedriver_linux64.zip
  if ! unzip -t chromedriver_linux64.zip >/dev/null; then
    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in storage"
    exit 0
  fi

  unzip -o ./chromedriver_linux64.zip -d "${TARGET_DIR}/.tmp/"
fi

#
# Try download from i-dont-remember-what-is-that
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  curl -O -L https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/"${CHROMEDRIVER_VERSION}"/linux64/chromedriver-linux64.zip
  if ! unzip -t chromedriver-linux64.zip >/dev/null; then
    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in edgedl"
    exit 0
  fi

  unzip -j -o ./chromedriver-linux64.zip -d "${TARGET_DIR}/.tmp/"
fi

#
# Ensure zip was downloaded
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  echo "ERROR: chromedriver ${CHROMEDRIVER_VERSION} not found"
  exit 1
fi

mv "${TARGET_DIR}/.tmp/chromedriver" "${TARGET_DIR}/chromedriver"
chmod -R 0777 "${TARGET_DIR}/chromedriver"
echo "INFO: chromedriver ${CHROMEDRIVER_VERSION} installed"

rm -rf "${TARGET_DIR}/.tmp/"
