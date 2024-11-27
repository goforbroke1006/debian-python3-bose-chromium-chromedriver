#!/usr/bin/env bash

set -e

TARGET_DIR=${1:-./build}
CHROMEDRIVER_VERSION=${2:-118.0.5993.70}

rm -rf "${TARGET_DIR}/.tmp/"
mkdir -p "${TARGET_DIR}/.tmp/"

##
## Try download from testing-public storage
##
#if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
#  echo "Try download from testing-public storage"
#
#  # curl -O -L https://storage.googleapis.com/chrome-for-testing-public/124.0.6367.201/linux64/chrome-linux64.zip
#  curl -O -L https://storage.googleapis.com/chrome-for-testing-public/"${CHROMEDRIVER_VERSION}"/linux64/chrome-linux64.zip
#  if ! unzip -t chrome-linux64.zip >/dev/null; then
#    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in storage (for-testing-public)"
#    exit 1
#  fi
#
#  unzip -o ./chrome-linux64.zip -d "${TARGET_DIR}/.tmp/"
#fi

#
# Try download from storage
# http://chromedriver.storage.googleapis.com/
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  echo "Try download from storage"

  #curl -O -L http://chromedriver.storage.googleapis.com/124.0.6367.201/chromedriver_linux64.zip
  curl -O -L http://chromedriver.storage.googleapis.com/"${CHROMEDRIVER_VERSION}"/chromedriver_linux64.zip
  if ! unzip -t chromedriver_linux64.zip >/dev/null; then
    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in storage"
  else
    echo "INFO: chromedriver ${CHROMEDRIVER_VERSION} found in storage..."
    unzip -o ./chromedriver_linux64.zip -d "${TARGET_DIR}/.tmp/"
    ls "${TARGET_DIR}/.tmp/"
  fi
fi

#
# Try download from i-dont-remember-what-is-that
#
if [[ ! -f "${TARGET_DIR}/.tmp/chromedriver" ]]; then
  echo "Try download from i-dont-remember-what-is-that"

  # curl -O -L https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/124.0.6367.201/linux64/chromedriver-linux64.zip
  curl -O -L https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/"${CHROMEDRIVER_VERSION}"/linux64/chromedriver-linux64.zip
  if ! unzip -t chromedriver-linux64.zip >/dev/null; then
    echo "WARN: chromedriver ${CHROMEDRIVER_VERSION} not found in edgedl"
  else
    echo "INFO: chromedriver ${CHROMEDRIVER_VERSION} found in edgedl..."
    unzip -j -o ./chromedriver-linux64.zip -d "${TARGET_DIR}/.tmp/"
    ls "${TARGET_DIR}/.tmp/"
  fi
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
echo "INFO: chromedriver ${CHROMEDRIVER_VERSION} installed into ${TARGET_DIR}/chromedriver"
"${TARGET_DIR}/chromedriver" --version

rm -rf "${TARGET_DIR}/.tmp/"
