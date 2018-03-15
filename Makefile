CONTAINER_NAME=marcelocorreia/go-glide-builder
CONTAINER_VERSION=0.0.1

##
REPO_NAME=go-glide-builder
IMAGE_GITHUB_RELEASE=socialengine/github-release
DOCKER_WORKING_DIR=/go/src/github.com/marcelocorreia/go-glide-builder
GITHUB_TOKEN?=
GITHUB_USER=marcelocorreia
RELEASE_VERSION=0.1
RELEASE_DESC="Go Glide Builder"
OUTPUT_DIR=./bin
OUTPUT_FILE=hello-world
# Test Stuff
TEST_APP=hello-world
TEST_NAMESPACE=github.com/marcelocorreia
IMAGE_GO_GLIDE=marcelocorreia/go-glide-builder:debian-stable-slim

CONCOURSE_EXTERNAL_URL ?=http://localhost:8080

default: test

git-push:
	git add .; git commit -m "Pipeline WIP"; git push

pipeline-login:
	fly -t dev login -n main -c $(CONCOURSE_EXTERNAL_URL)

set-pipeline: git-push
	fly -t dev set-pipeline \
		-n -p go-glide-builder \
		-c cicd/pipelines/pipeline.yml \
		-l /Users/marcelo/.ssh/ci-credentials.yml \
		-v git_repo_url=git@github.com:marcelocorreia/go-glide-builder.git \
        -v container_fullname=marcelocorreia/go-glide-builder \
        -v container_name=go-glide-builder
	fly -t dev unpause-pipeline -p go-glide-builder
	fly -t dev trigger-job -j go-glide-builder/go-glide-builder

trigger-job:
	fly -t dev trigger-job -j go-glide-builder/go-glide-builder
.PHONY: trigger-job

watch-job:
	fly -t dev watch -j go-glide-builder/go-glide-builder
.PHONY: watch-job


build:
	docker build -t $(CONTAINER_NAME):$(CONTAINER_VERSION) .
	docker build -t $(CONTAINER_NAME):latest .
.PHONY: build

docker-shell:
	docker run --rm -it marcelocorreia/go-glide-builder bash


test:
	@docker run --rm \
	-v $(shell pwd):/go/src/$(TEST_NAMESPACE)/$(TEST_APP) \
	-w /go/src/$(TEST_NAMESPACE)/$(TEST_APP) \
	$(CONTAINER_NAME):$(CONTAINER_VERSION) \
	bash -c "glide install; go fmt .; go test -v; go build -o ./bin/$(TEST_APP)"
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

package: clean test
	$(call buildLinuxPackage)

clean:
	@rm -rf bin/* ./dist/* ./tmp/*


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

define bumpVersionMinor
	docker run --rm \
    -v $(shell pwd):$(DOCKER_WORKING_DIR) \
    -w $(DOCKER_WORKING_DIR) \
    $(IMAGE_GO_GLIDE) \
    bash -c "github-release  $1 -s $(GITHUB_TOKEN) -u $(GITHUB_USER) -r $(REPO_NAME) $2"
endef