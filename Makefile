IMAGE_NAME = py
TAG = v2.0
REPO = aaweaver9/$(IMAGE_NAME)

.PHONY: build shell push

build:
	docker build -t $(IMAGE_NAME):$(TAG) -f py-dev.Dockerfile .

shell:
	docker run --rm -it $(IMAGE_NAME):$(TAG) /usr/bin/zsh

push:
	docker tag $(IMAGE_NAME):$(TAG) $(REPO):$(TAG)
	docker push $(REPO):$(TAG)
	docker tag $(IMAGE_NAME):$(TAG) $(REPO):latest
	docker push $(REPO):latest