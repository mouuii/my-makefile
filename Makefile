
BIN_DIR := $(GOPATH)/bin
PKGS := $(shell go list ./... | grep -v /vendor)
LINTER := $(BIN_DIR)/golangci-lint

.PHONY: test lint

test: lint
	go test $(PKGS)

lint: $(LINTER)
	golangci-lint run -E golint  -E gochecknoinits -E goconst -E goimports -E misspell

$(LINTER):
	go get -u github.com/golangci/golangci-lint/cmd/golangci-lint@v1.17.1
	golangci-lint run &> /dev/null



BINARY := mytool
VERSION ?= vlatest
PLATFORMS := windows linux darwin
os = $(word 1, $@)
.PHONY: $(PLATFORMS)
$(PLATFORMS):
	 mkdir -p release
	 GOOS=$(os) GOARCH=amd64 go build -o release/$(BINARY)-$(VERSION)-$(os)-amd64 ./cmd
.PHONY: release
release: test windows linux darwin