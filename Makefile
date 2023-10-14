IMAGE_NAME=docker.io/goforbroke1006/debian-python3-chromium-chromedriver

# https://packages.debian.org/sid/chromium
CHROME_VERSION=118.0.5993.70-1
# http://chromedriver.storage.googleapis.com/ OR https://googlechromelabs.github.io/chrome-for-testing/#stable
CHROMEDRIVER_VERSION=118.0.5993.70

image:
	docker pull $(IMAGE_NAME):$(CHROMEDRIVER_VERSION) || true
	docker build --pull -f ./Dockerfile -t $(IMAGE_NAME):$(CHROMEDRIVER_VERSION) \
		--build-arg CHROME_VERSION=$(CHROME_VERSION) \
		--build-arg CHROMEDRIVER_VERSION=$(CHROMEDRIVER_VERSION) \
		.
.PHONY: image

publish: image
	docker login docker.io
	docker push $(IMAGE_NAME):$(CHROMEDRIVER_VERSION)
.PHONY: publish
