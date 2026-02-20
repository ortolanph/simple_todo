import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:printing/printing.dart';
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/repository/todo_repository.dart';
import 'package:simple_todo/style/todo_styles.dart';
import 'package:simple_todo/utils/pdf_creator.dart';
import 'package:simple_todo/widget/todo_widget.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger("home_page");
  final TodoRepository _todoRepository = autoInjector.get<TodoRepository>();

  TextEditingController newTodoController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "A simple TO DO list",
          style: TodoTypography.appTitle.textstyle!,
        ),
        actions: [
          IconButton(
            onPressed: () {
              logger.info("Cleaning all Todos");
              _todoRepository.deleteAll();
            },
            icon: const Icon(Icons.cleaning_services_rounded),
            tooltip: "Add a new task",
          ),
          IconButton(
            onPressed: () async {
              logger.info("Generating PDF");
              final pdf = await generatePDFReport(_todoRepository.box.values.toList());

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('PDF Preview'),
                  content: Container(
                    width: double.maxFinite,
                    height: 400,
                    child: PdfPreview(
                      build: (format) => pdf.save(),
                      allowPrinting: true, // Disable direct printing if needed
                      allowSharing: true, // Enable sharing
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );

            },
            icon: const FaIcon(FontAwesomeIcons.filePdf),
            tooltip: "Generate PDF",
          ),
          IconButton(
            onPressed: () {
              logger.info("Generating CSV");
            },
            icon: const FaIcon(FontAwesomeIcons.fileCsv),
            tooltip: "Generating CSV",
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            autovalidateMode: AutovalidateMode.always,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: newTodoController,
                style: TodoTypography.todoLine.textstyle!,
                decoration: InputDecoration(
                  hintText: "Input a task to do",
                  suffixIcon: IconButton(
                      onPressed: () {
                        logger.info("Adding todo ${newTodoController.text}");
                        Todo todo = Todo(
                            id: const Uuid().v4(),
                            task: newTodoController.text,
                            done: false);

                        _todoRepository.add(todo);

                        setState(() {
                          newTodoController.text = "";
                        });
                      },
                      icon: const Icon(Icons.add)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Box<Todo>>(
              valueListenable: _todoRepository.box.listenable(),
              builder: (BuildContext context, Box<Todo> box, _) =>
                  ListView.builder(
                shrinkWrap: true,
                itemCount: box.length,
                itemBuilder: (context, index) {
                  var value = _todoRepository.box.getAt(index);
                  return TodoWidget(todo: value!, todoIndex: index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
