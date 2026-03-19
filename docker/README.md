# simple_todos

A simple Flutter application of a TODO list with options to import to a PDF Document and CSV file.

## Versions

 * [1.0.0 - Initial Version - PDF and CSV support](https://hub.docker.com/repository/docker/ortolanph/simple_todos/tags/1.0.0/sha256-1b44a114e566102c48aabdcdb1cb4cb7f981df2bcc5b91190b36c31385cd5cb0)
 * [2.0.0 - Excel support](https://hub.docker.com/repository/docker/ortolanph/simple_todos/tags/2.0.0/sha256-1a9f845916e1762516161e2a46715a4643abc4324b2e17dfbe48510edc25de6e)

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

## Source Code

Please refer to the source code: https://github.com/ortolanph/simple_todo. If you find a bug, just create an issue.
