import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/main.dart';
import 'package:simple_todo/repository/todo_repository.dart';
import 'package:simple_todo/style/todo_styles.dart';

import '../data/todo.dart';

class TodoWidget extends StatefulWidget {
  const TodoWidget({
    super.key,
    required this.todo,
    required this.todoIndex,
  });

  final Todo todo;
  final int todoIndex;

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  Logger logger = Logger("todo_widget");
  bool checkBoxValue = false;
  final TodoRepository _repository = autoInjector.get<TodoRepository>();

  @override
  void initState() {
    checkBoxValue = widget.todo.done;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: checkBoxValue,
            onChanged: (bool? value) async {
              logger.info("Changed the value to $value");

              setState(() {
                checkBoxValue = value!;
              });

              widget.todo.done = checkBoxValue;
              await _repository.update(widget.todoIndex, widget.todo);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.todo.task,
              style: (checkBoxValue)
                  ? TodoTypography.todoDone.textstyle!
                  : TodoTypography.todoNotDone.textstyle!,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              logger.info("Deleting task ${widget.todo.task}");
              _repository.delete(widget.todoIndex);
            },
            icon: const Icon(FontAwesomeIcons.trash),
          ),
        ],
      ),
    );
  }
}
