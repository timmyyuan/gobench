export GOBENCH_ROOT_PATH=/root/gobench
MOUNT_DOCKER=-v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker
MOUNT_GOBENCH=-v $(shell pwd):/root/gobench

test:
	go test . -v -count 1 -run TestGoKer

test-suite-goker:
	go test -v -count 1 -timeout 48h . -run TestArtifactGoKer

test-suite-goreal:
	go test -v -count 1 -timeout 48h . -run TestArtifactGoReal

test-suite-simple-spec:
	go test -v -count 1 -timeout 48h . -run TestArtifactSimpleSpecific

test-suite-simple-goker:
	go test -v -count 1 -timeout 48h . -run TestArtifactSimpleGoKer

test-suite-simple-goreal:
	go test -v -count 1 -timeout 48h . -run TestArtifactSimpleGoReal

test-suite-simple-race:
	go test -v -count 1 -timeout 48h . -run TestArtifactSimpleRace

simple:
	cd ./dockerfiles/goreal/ && docker build -t gobench:goreal . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_DOCKER) $(MOUNT_GOBENCH) gobench:goreal make test-suite-simple-goreal
	cd ./dockerfiles/goker/ && docker build -t gobench:goker . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_GOBENCH) gobench:goker make test-suite-simple-goker

simple-spec:
	cd ./dockerfiles/goreal/ && docker build -t gobench:goreal . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_DOCKER) $(MOUNT_GOBENCH) gobench:goreal make test-suite-simple-spec

simple-race:
	cd ./dockerfiles/goreal/ && docker build -t gobench:goreal . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_DOCKER) $(MOUNT_GOBENCH) gobench:goreal make test-suite-simple-race

goreal:
	cd ./dockerfiles/goreal/ && docker build -t gobench:goreal . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_DOCKER) $(MOUNT_GOBENCH) gobench:goreal make test-suite-goreal

goker:
	cd ./dockerfiles/goker/ && docker build -t gobench:goker . -f Dockerfile && cd ../..
	docker run --rm $(MOUNT_GOBENCH) gobench:goker make test-suite-goker

test-web:
	go run cmd/web/main.go

test-dockerfile:
	go test -v -count 1 . -run TestGoRealImageBuildAndRun

pdf:
	cd ./dockerfiles/ && docker build -t gobench:pdf . -f Dockerfile && cd ..
	docker run --rm $(MOUNT_GOBENCH) -w /root/gobench/cmd/pdf -e GOBENCH_ROOT_PATH=$(GOBENCH_ROOT_PATH) gobench:pdf go run main.go

all: goker goreal pdf