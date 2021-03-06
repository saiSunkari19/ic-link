PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags --always) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
COSMOS_SDK := $(shell grep -i cosmos-sdk go.mod | awk '{print $$2}')
TEST_DOCKER_REPO=saisunkari19/ic-link

build_tags := $(strip netgo $(build_tags))

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=iclink \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=icd \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=iccli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X "github.com/cosmos/cosmos-sdk/version.BuildTags=$(build_tags),cosmos-sdk $(COSMOS_SDK)"

BUILD_FLAGS := -ldflags '$(ldflags)'

all: go.sum install

create-wallet:
	iccli keys add validator

init:
	rm -rf ~/.icd
	icd init ic  --chain-id ic --stake-denom fmt
	icd add-genesis-account $(shell iccli keys show validator -a) 1000000000000fmt,1000000000000mdm
	icd gentx --name=validator --amount 100000000fmt
	icd collect-gentxs

install: go.sum
		go install -mod=readonly $(BUILD_FLAGS) ./cmd/icd
		go install -mod=readonly $(BUILD_FLAGS) ./cmd/iccli
build:
		go build -o bin/icd ./cmd/icd
		go build -o bin/iccli ./cmd/iccli

go.sum: go.mod
		@echo "--> Ensure dependencies have not been modified"
		GO111MODULE=on go mod verify

lint:
	@echo "--> Running linter"
	@golangci-lint run
	@go mod verify


docker-test:
	@docker build -f Dockerfile.test -t ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD) .
	@docker push ${TEST_DOCKER_REPO}:$(shell git rev-parse --short HEAD)

.PHONY: build install docker-test