#!/usr/bin/env bash

set -e

CHROME_VERSION=${1:-114.0.5735.133}

echo "Look for Chrome ${CHROME_VERSION}"


if [[ -f /chrome/"${CHROME_VERSION}"/chrome-linux64.zip ]]; then
  echo "INFO: Try install from local files..."

  mkdir -p /desired/location
  unzip /chrome/"${CHROME_VERSION}"/chrome-linux64.zip -d /desired/location

  if [[ ! -f /desired/location/chrome-linux64/chrome ]]; then
    echo "ERROR: /desired/location/chrome-linux64/chrome not found!"
    exit 1
  fi

  mv /desired/location/chrome-linux64 /opt/google-chrome
  ls /opt/google-chrome/
  ln -s /opt/google-chrome/chrome /usr/bin/google-chrome

  google-chrome --version

  rm -rf /desired/location
  rm -rf /chrome/

  exit 0
fi





# TODO: fix it

#RUN apt-get install -y wget
#RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
#      && apt-get install -y /tmp/chrome.deb \
#      && rm /tmp/chrome.deb
#RUN apt-get install -y wget gnupg
#RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
#RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
#RUN apt-get update
#RUN apt-get install -y google-chrome-stable=${CHROME_VERSION}
#RUN google-chrome -version


# All versions here
# https://googlechromelabs.github.io/chrome-for-testing/known-good-versions-with-downloads.json

#
# Try download from testing-public storage
#
echo "Try download from testing-public storage"

# curl -O -L https://storage.googleapis.com/chrome-for-testing-public/114.0.5735.133/linux64/chrome-linux64.zip
# curl -O -L https://storage.googleapis.com/chrome-for-testing-public/124.0.6367.201/linux64/chrome-linux64.zip
curl -O -L https://storage.googleapis.com/chrome-for-testing-public/"${CHROME_VERSION}"/linux64/chrome-linux64.zip
if ! unzip -t chrome-linux64.zip >/dev/null; then
  echo "WARN: chrome ${CHROME_VERSION} not found in storage (for-testing-public)"
else
  unzip chrome-linux.zip -d /desired/location
  mv /desired/location/chrome /opt/google-chrome
  ln -s /opt/google-chrome/chrome /usr/bin/google-chrome

  apt-get update
  apt-get install -y libnss3 libxss1 libgconf-2-4 libappindicator1 fonts-liberation xdg-utils
  google-chrome --version

  rm -rf /desired/location
  rm -f chrome-linux64.zip
fi
