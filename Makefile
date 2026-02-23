.PHONY: clean compile dependencies analyze fix build help

help:
	@echo "Available targets:"
	@echo "  clean          - Clean Flutter cache and project"
	@echo "  compile        - Run build_runner (includes dependencies)"
	@echo "  dependencies   - Get Dart dependencies"
	@echo "  analyze        - Analyze Dart code"
	@echo "  fix            - Apply Dart fixes (includes analyze)"
	@echo "  build          - Build web app for production (includes clean & compile)"
	@echo "  docker-build   - Build a local docker image"
	@echo "  docker-run     - Runs a local docker image"
	@echo "  docker-publish - Publishes a new version of the image on docker hub"


clean:
	flutter clean cache
	flutter clean

dependencies:
	dart pub get

compile: clean dependencies
	dart run build_runner build -d

analyze:
	dart analyze

fix: analyze
	dart fix --apply

build: clean compile
	flutter build web --base-href /

docker-build: build
	docker login
	docker build -t simple_todos:local .

docker-run: build
	docker run -d -p 8080:80 --name simple_todos_local simple_todos:local

check_next_version:
	@if [ -n "$(NEXT_VERSION)" ]; then \
		echo "Next version will be $(NEXT_VERSION)"; \
	else \
		echo "NEXT_VERSION is empty, aborting."; \
		echo "Run; make docker-publish 1.0.0"; \
		exit 1; \
	fi

docker-publish: check_next_version
	docker login
	docker build -t simple_todos:${NEXT_VERSION} .
	docker tag simple_todos:${NEXT_VERSION} ortolanph/simple_todos:${NEXT_VERSION}
	docker tag simple_todos:${NEXT_VERSION} ortolanph/simple_todos:latest
	docker push ortolanph/simple_todos:${NEXT_VERSION}
	docker push ortolanph/simple_todos:latest
