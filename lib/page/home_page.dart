import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/repository/todo_repository.dart';
import 'package:simple_todo/style/todo_styles.dart';
import 'package:simple_todo/utils/report_creator.dart';
import 'package:simple_todo/widget/todo_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

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
              final pdf =
                  generatePDFReport(_todoRepository.box.values.toList());

              final pdfBytes = await pdf.save();
              final timeStamp = dateFormat.format(DateTime.now());
              final fileName = "todos_$timeStamp.pdf";
              final mimeType = "application/pdf";

              downloadFile(pdfBytes, mimeType, fileName);
              showSnackBar(context, "PDF File Generated with success");
            },
            icon: const FaIcon(FontAwesomeIcons.filePdf),
            tooltip: "Generate PDF",
          ),
          IconButton(
            onPressed: () {
              logger.info("Generating CSV");

              final csvBytes =
                  csvGenerator(_todoRepository.box.values.toList());
              final timeStamp = dateFormat.format(DateTime.now());
              final fileName = "todos_$timeStamp.csv";
              final mimeType = "text/csv";

              downloadFile(csvBytes, mimeType, fileName);

              showSnackBar(context, "CSV File Generated with success");
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

  void showSnackBar(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void downloadFile(Uint8List pdfBytes, String mimeType, String fileName) {
    final blob = web.Blob(
      [pdfBytes.buffer.toJS].toJS,
      web.BlobPropertyBag(type: '$mimeType;charset=utf-8;'),
    );

    final url = web.URL.createObjectURL(blob);

    // Create a temporary <a> and click it
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..setAttribute('download', fileName)
      ..click();

    web.URL.revokeObjectURL(url);
  }
}
