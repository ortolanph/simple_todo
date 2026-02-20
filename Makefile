.PHONY: clean compile dependencies analyze fix build help

help:
	@echo "Available targets:"
	@echo "  clean        - Clean Flutter cache and project"
	@echo "  compile      - Run build_runner (includes dependencies)"
	@echo "  dependencies - Get Dart dependencies"
	@echo "  analyze      - Analyze Dart code"
	@echo "  fix          - Apply Dart fixes (includes analyze)"
	@echo "  build        - Build web app for production (includes clean & compile)"

clean:
	flutter clean cache
	flutter clean

dependencies:
	dart pub get

compile: clean
	dart run build_runner build -d

analyze:
	dart analyze

fix: analyze
	dart fix --apply

build: clean compile
	flutter build web --base-href /

docker-build:
	docker login
	docker build -t flutter-todos-web .

docker-run:
	docker run -d -p 8080:80 --name todos-web flutter-todos-web