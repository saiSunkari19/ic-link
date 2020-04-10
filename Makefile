PACKAGES=$(shell go list ./... | grep -v '/simulation')

VERSION := $(shell echo $(shell git describe --tags --always) | sed 's/^v//')
COMMIT := $(shell git log -1 --format='%H')
COSMOS_SDK := $(shell grep -i cosmos-sdk go.mod | awk '{print $$2}')


build_tags := $(strip netgo $(build_tags))

ldflags = -X github.com/cosmos/cosmos-sdk/version.Name=interchain \
	-X github.com/cosmos/cosmos-sdk/version.ServerName=icd \
	-X github.com/cosmos/cosmos-sdk/version.ClientName=iccli \
	-X github.com/cosmos/cosmos-sdk/version.Version=$(VERSION) \
	-X github.com/cosmos/cosmos-sdk/version.Commit=$(COMMIT) \
	-X "github.com/cosmos/cosmos-sdk/version.BuildTags=$(build_tags),cosmos-sdk $(COSMOS_SDK)"

BUILD_FLAGS := -ldflags '$(ldflags)'

all: go.sum install

init:
	rm -rf ~/.icd
	icd init ic --stake-denom stake
	icd add-genesis-account $(shell iccli keys show validator -a) 10000000000stake
	icd gentx --name=validator --amount 10000000000stake
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
	docker build -f Dockerfile.test -t ic-link/ic-relayer:final .

.PHONY: build install docker-test