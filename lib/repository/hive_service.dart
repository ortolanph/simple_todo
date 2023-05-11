import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

import '../data/todo.dart';

class HiveService {
  Box<Todo>? _todoBox;
  Logger logger = Logger("hive_service");

  Future<void> init() async {
    logger.info("Initilize Hive");
    await Hive.initFlutter();
    logger.info("Registering adapters");
    Hive.registerAdapter(TodoAdapter());

    logger.info("Opening boxes");
    _todoBox = await Hive.openBox<Todo>(
      "todos",
    );
  }

  // Boxes
  Box<Todo> get todoBox {
    if (_todoBox == null) {
      logger.severe("Hive box Todos not initialized.");
      throw Exception("Hive box Todos not initialized.");
    }

    return _todoBox!;
  }
}
