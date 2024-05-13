IMAGE_NAME=docker.io/goforbroke1006/debian-python3-bose-chromium-chromedriver

# https://packages.debian.org/sid/chromium
# http://chromedriver.storage.googleapis.com/ OR https://googlechromelabs.github.io/chrome-for-testing/#stable

#.ONESHELL:
#image/090: CHROME_VERSION       = 90.0.4430.72-0
#image/090: CHROMEDRIVER_VERSION = 90.0.4430.24
#image/090: DOCKERFILE = Dockerfile
#image/090: image
#.PHONY: image/090

.ONESHELL:
image/114: CHROME_VERSION       = 114.0.5735.198-1
image/114: CHROMEDRIVER_VERSION = 114.0.5735.90
image/114: DOCKERFILE           = ./direct-deb.Dockerfile
image/114: image
.PHONY: image/114

#.ONESHELL:
#image/118: CHROME_VERSION       = 118.0.5993.70-1
#image/118: CHROMEDRIVER_VERSION = 118.0.5993.70
#image/118: DOCKERFILE           = ./Dockerfile
#image/118: image
#.PHONY: image/118

.ONESHELL:
image/124: CHROME_VERSION       = 124.0.6367.201-1
image/124: CHROMEDRIVER_VERSION = 124.0.6367.201
image/124: DOCKERFILE           = ./direct-deb.Dockerfile
image/124: image
.PHONY: image/124

image:
	docker pull $(IMAGE_NAME):$(CHROMEDRIVER_VERSION) || true
	docker build --pull -f $(DOCKERFILE) -t $(IMAGE_NAME):$(CHROMEDRIVER_VERSION) \
		--build-arg CHROME_VERSION=$(CHROME_VERSION) \
		--build-arg CHROMEDRIVER_VERSION=$(CHROMEDRIVER_VERSION) \
		--progress plain \
		.
.PHONY: image

publish:
	docker login docker.io
	docker push $(IMAGE_NAME) --all-tags
.PHONY: publish
