# simple_todos

A simple Flutter application of a TODO list with options to import to a PDF Document and CSV file.

## Running

```shell
docker push ortolanph/simple_todos
docker run -d -p 10132:8080 --name ortolanph/simple_todos simple_todos_application
```

## Docker Compose

```yaml
services:
  simple_todo_app:
    container_name: simple_todos_application
    image: ortolanph/simple_todos:1.0.0
    ports:
      - "10132:8080"
    networks:
      - simple_todo_network

networks:
  simple_todo_network:
    driver: bridge
```