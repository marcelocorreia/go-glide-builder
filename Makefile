CONTAINER_NAME=marcelocorreia/go-glide-builder
CONTAINER_VERSION=0.0.1
IMAGE_SOURCE=debian/jessie-slim

# Test Stuff
TEST_APP=hello-world
TEST_NAMESPACE=github.com/marcelocorreia

default: check

build:
	docker build -t $(CONTAINER_NAME):$(CONTAINER_VERSION) .
	docker build -t $(CONTAINER_NAME):latest .
.PHONY: build

test:
	docker run --rm \
	-v $(shell pwd):/go/src/$(TEST_NAMESPACE)/$(TEST_APP) \
	-w /go/src/$(TEST_NAMESPACE)/$(TEST_APP) \
	$(CONTAINER_NAME):$(CONTAINER_VERSION) \
	bash -c "glide install; go fmt .; go test -v; go build -o ./bin/$(TEST_APP)"
	sudo chown -R $(shell whoami): ./bin ./vendor ./.glide
	./bin/$(TEST_APP)
.PHONY: test

push: build
	docker push $(CONTAINER_NAME):$(CONTAINER_VERSION)
	docker push $(CONTAINER_NAME):latest
.PHONY: push

