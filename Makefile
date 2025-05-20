IMAGE_NAME = python-devcontainer
TAG = latest
REPO = your-docker-repo/$(IMAGE_NAME)

.PHONY: build shell push

build:
	docker build -t $(IMAGE_NAME):$(TAG) .

shell:
	docker run --rm -it $(IMAGE_NAME):$(TAG) /usr/bin/zsh

push:
	docker tag $(IMAGE_NAME):$(TAG) $(REPO):$(TAG)
	docker push $(REPO):$(TAG)