FROM debian:bookworm-slim

RUN apt update
RUN #apt upgrade -y

RUN apt install -y curl unzip

RUN apt-get install python3.11 python3-pip python3.11-venv -y
RUN python3 --version

# https://packages.debian.org/sid/chromium
ARG CHROME_VERSION='114.0.5735.198-1'
ARG CHROMIUM_DEB_VERSION="${CHROME_VERSION}~deb12u1"
# http://chromedriver.storage.googleapis.com/ OR https://googlechromelabs.github.io/chrome-for-testing/#stable
ARG CHROMEDRIVER_VERSION='114.0.5735.90'

RUN #apt list -a chromium-common
RUN apt-cache madison chromium-common && echo '1'
RUN apt install -y \
    chromium-common=$CHROMIUM_DEB_VERSION \
    chromium-sandbox=$CHROMIUM_DEB_VERSION \
    chromium=$CHROMIUM_DEB_VERSION

WORKDIR /code/

COPY ./get-chromedriver.sh /get-chromedriver.sh
RUN mkdir -p /code/build/
#RUN curl -O -L http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip
#RUN unzip ./chromedriver_linux64.zip -d /code/build/
#RUN chmod -R 0777 /code/build/
#RUN curl -O -L https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip
#RUN unzip -j ./chromedriver-linux64.zip -d /code/build/
#RUN chmod -R 0777 /code/build/
RUN bash /get-chromedriver.sh /code/build/ ${CHROMEDRIVER_VERSION}

ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=utf-8
ENV PYTHONLEGACYWINDOWSSTDIO=utf-8
ENV ENV=production
