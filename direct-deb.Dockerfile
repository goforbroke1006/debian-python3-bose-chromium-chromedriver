FROM debian:bookworm-20221219-slim

RUN apt update
RUN #apt upgrade -y

RUN apt install -y curl unzip

RUN apt-get install python3.11 python3-pip python3.11-venv -y
RUN python3 --version

# https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_114.0.5735.198-1_amd64.deb
ARG CHROME_VERSION='114.0.5735.198-1'
# http://chromedriver.storage.googleapis.com/ OR https://googlechromelabs.github.io/chrome-for-testing/#stable
ARG CHROMEDRIVER_VERSION='114.0.5735.90'

RUN apt install -y wget
RUN wget --no-verbose -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
      && apt install -y /tmp/chrome.deb \
      && rm /tmp/chrome.deb
RUN google-chrome -version

WORKDIR /code/

COPY ./get-chromedriver.sh /get-chromedriver.sh
RUN mkdir -p /code/build/
RUN bash /get-chromedriver.sh /code/build/ ${CHROMEDRIVER_VERSION}

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8
ENV PYTHONLEGACYWINDOWSSTDIO=utf-8
ENV ENV=production
