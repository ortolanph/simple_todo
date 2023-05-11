import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

import '../data/todo.dart';
import 'hive_service.dart';

class TodoRepository {
  HiveService _hiveService;
  Logger logger = Logger("todo_repository");

  TodoRepository(HiveService hiveService) : _hiveService = hiveService;

  Box<Todo> get box => _hiveService.todoBox;

  Future<void> deleteAll() async {
    logger.info("Deleting all Todos");
    box.deleteAll(box.keys);
  }

  Future<int> add(Todo todo) {
    logger.info("Adding a Todo");
    return box.add(todo);
  }

  Future<void> update(int index, Todo todo) {
    logger.info("Updating a Todo");
    return box.putAt(index, todo);
  }

  Future<void> delete(int index) async {
    logger.info("Updating a Todo");
    return box.deleteAt(index);
  }
}