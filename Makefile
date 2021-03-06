.PHONY: all container push clean node-problem-detector

all: push

# See node-problem-detector.yaml for the version currently running-- bump this ahead before rebuilding!
TAG = v0.2

PROJ = google_containers

PKG_SOURCES := $(shell find pkg -name '*.go')

node-problem-detector: ./bin/node-problem-detector

./bin/node-problem-detector: $(PKG_SOURCES) node_problem_detector.go
	CGO_ENABLED=0 GOOS=linux godep go build -a -installsuffix cgo -ldflags '-w' -o node-problem-detector

test:
	go test -timeout=1m -v -race ./pkg/...

container: node-problem-detector
	docker build -t gcr.io/$(PROJ)/node-problem-detector:$(TAG) .

push: container
	gcloud docker push gcr.io/$(PROJ)/node-problem-detector:$(TAG)

clean:
	rm -f ./bin/node-problem-detector
