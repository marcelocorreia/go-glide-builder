CONTAINER_NAME=marcelocorreia/go-glide-builder
CONTAINER_VERSION=0.0.1

# Test Stuff
TEST_APP=hello-world
TEST_NAMESPACE=github.com/marcelocorreia

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

github-info:
	@$(call githubRelease, info)
.PHONY: github-info

github-release: package
	@$(call githubRelease, release, -t "$(RELEASE_VERSION)")

github-upload:
	@$(call githubRelease, upload, -t "$(RELEASE_VERSION)" -f "./dist/linux/$(OUTPUT_FILE)-$(RELEASE_VERSION)-linux-amd64.tar.gz" -n "$(OUTPUT_FILE)-$(RELEASE_VERSION)-linux-amd64.tar.gz")

package: _clean test
	$(call buildLinuxPackage)

_clean:
	@rm -rf bin/* ./dist/* ./tmp/*

pipeline:
	fly -t ci set-pipeline -p go-glide-builder -c ./ci/build.yml

##
define githubRelease
	docker run --rm \
    -v $(shell pwd):$(DOCKER_WORKING_DIR) \
    -w $(DOCKER_WORKING_DIR) \
    $(IMAGE_GITHUB_RELEASE) \
    bash -c "github-release  $1 -s $(GITHUB_TOKEN) -u $(GITHUB_USER) -r $(REPO_NAME) $2"
endef

define buildLinuxPackage
    @[ -f ./dist/linux ] && echo dist folder found, skipping creation || mkdir -p ./dist/linux
    tar -cvzf ./dist/linux/$(OUTPUT_FILE)-$(RELEASE_VERSION)-linux-amd64.tar.gz -C ./bin .
endef