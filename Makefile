CONTAINER_NAME=marcelocorreia/go-glide-builder
CONTAINER_VERSION=0.0.1
IMAGE_SOURCE=debian/jessie-slim

#
GO_DOWNLOAD_URL=https://storage.googleapis.com/golang
GO_PACKAGE=go1.8.linux-amd64.tar.gz
GLIDE_DOWNLOAD_URL=https://github.com/Masterminds/glide/releases/download/v0.12.3
GLIDE_PACKAGE=glide-v0.12.3-linux-amd64.tar.gz

#
RESOURCES_DIR=./resources

# Test Stuff
TEST_APP=hello-world
TEST_NAMESPACE=github.com/marcelocorreia

default: check

build:
	docker build -t $(CONTAINER_NAME):$(CONTAINER_VERSION) .
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
.PHONY: push

download:
	@[ -f "$(RESOURCES_DIR)/$(GO_PACKAGE)" ] && echo Go package found, skipping download || $(call download_go)
	@[ -f "$(RESOURCES_DIR)/$(GLIDE_PACKAGE)" ] && echo Glide package found, skipping download || $(call download_glide)
.PHONY: download

define download_go
	curl $(GO_DOWNLOAD_URL)/$(GO_PACKAGE) -o $(RESOURCES_DIR)/$(GO_PACKAGE)
endef

define download_glide
	wget $(GLIDE_DOWNLOAD_URL)/$(GLIDE_PACKAGE) -o $(RESOURCES_DIR)/$(GLIDE_PACKAGE)
endef
