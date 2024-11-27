FROM debian:bookworm-20221219-slim AS base

RUN apt-get update && apt-get upgrade -y

RUN apt install -y curl unzip

ARG PYTHON_VERSION='3.11'
RUN apt-get install python${PYTHON_VERSION} python${PYTHON_VERSION}-venv -y
RUN python3 --version

#

# https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb
# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb
# https://storage.googleapis.com/chrome-for-testing-public/114.0.5735.133/linux64/chrome-linux64.zip
ARG CHROME_VERSION='114.0.5735.198-1'


RUN apt-get update
RUN apt-get install -y libnss3 libxss1 libgconf-2-4 libappindicator1 fonts-liberation xdg-utils
RUN apt-get install -y libatk-bridge2.0-0
RUN apt-get install -y libxkbcommon0
RUN apt-get install -y libasound2
ADD ./chrome /chrome
COPY ./get-chrome.sh /get-chrome.sh
RUN bash /get-chrome.sh ${CHROME_VERSION}
RUN google-chrome -version

#

WORKDIR /code/

# http://chromedriver.storage.googleapis.com/ OR https://googlechromelabs.github.io/chrome-for-testing/#stable
ARG CHROMEDRIVER_VERSION='114.0.5735.90'


COPY ./get-chromedriver.sh /get-chromedriver.sh
RUN mkdir -p /code/build/
RUN bash /get-chromedriver.sh /code/build/ ${CHROMEDRIVER_VERSION}
RUN /code/build/chromedriver --version
# I download driver right to /code/build/chromedriver because BOSE framework would look for driver in this location.

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8
ENV PYTHONLEGACYWINDOWSSTDIO=utf-8
ENV ENV=production

# Chome installed
# Crome driver for selenium here /code/build/chromedriver

#
#
#

FROM base AS display

RUN mkdir -p /code/build/
COPY --from=base /code/build/chromedriver /code/build/chromedriver

RUN apt-get update
RUN apt-get install -y xvfb \
                       libnss3 libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 \
                       libappindicator3-1 fonts-liberation libasound2 libpangocairo-1.0-0

ENV DISPLAY=:99

RUN echo '#!/bin/bash \n\
\n\
/usr/bin/google-chrome --version\n\
/code/build/chromedriver --version\n\
\n\
Xvfb :99 -screen 0 1920x1080x24 & \n\
\n\
exec "$@" \n\
' > /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
