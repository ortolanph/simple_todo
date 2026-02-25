import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/repository/todo_repository.dart';
import 'package:simple_todo/style/todo_styles.dart';
import 'package:simple_todo/utils/report_strategy.dart';
import 'package:simple_todo/widget/todo_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

import '../main.dart';

// ignore_for_file: use_build_context_synchronously
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger("home_page");
  final TodoRepository _todoRepository = autoInjector.get<TodoRepository>();

  final ReportStrategy reportStrategy = ReportStrategy();

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
              final pdf = await reportStrategy
                  .getReportCreator(ReportType.pdf)
                  .generateReport(_todoRepository.box.values.toList());

              downloadFile(pdf, ReportType.pdf);
              showSnackBar(context, "PDF File Generated with success");
            },
            icon: const FaIcon(FontAwesomeIcons.filePdf),
            tooltip: "Export to PDF",
          ),
          IconButton(
            onPressed: () async {
              logger.info("Generating CSV");
              final csvBytes = await reportStrategy
                  .getReportCreator(ReportType.csv)
                  .generateReport(_todoRepository.box.values.toList());

              downloadFile(csvBytes, ReportType.csv);

              showSnackBar(context, "CSV File Generated with success");
            },
            icon: const FaIcon(FontAwesomeIcons.fileCsv),
            tooltip: "Export to CSV",
          ),
          IconButton(
            onPressed: () async {
              logger.info("Generate Excel");
              final excelBytes = await reportStrategy
                  .getReportCreator(ReportType.excel)
                  .generateReport(_todoRepository.box.values.toList());

              downloadFile(excelBytes, ReportType.excel);

              showSnackBar(context, "Unimplemented");
            },
            icon: const FaIcon(FontAwesomeIcons.fileExcel),
            tooltip: "Export to Excel",
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
                onSubmitted: (value) {
                  logger.info("Adding todo $value");
                  _createTodo(value);
                },
                style: TodoTypography.todoLine.textstyle!,
                decoration: InputDecoration(
                  hintText: "Input a task to do",
                  suffixIcon: IconButton(
                      onPressed: () {
                        logger.info("Adding todo ${newTodoController.text}");
                        _createTodo(newTodoController.text);
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

  void _createTodo(String newTask) {
    Todo todo = Todo(
        id: const Uuid().v4(),
        task: newTask,
        done: false);

    _todoRepository.add(todo);

    setState(() {
      newTodoController.text = "";
    });
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

  void downloadFile(Uint8List pdfBytes, ReportType reportType) {
    final timeStamp = dateFormat.format(DateTime.now());
    final fileName = "todos_$timeStamp.${reportType.extension}";

    final blob = web.Blob(
      [pdfBytes.buffer.toJS].toJS,
      web.BlobPropertyBag(type: '${reportType.mimeType};charset=utf-8;'),
    );

    final url = web.URL.createObjectURL(blob);

    // Create a temporary <a> and click it
    web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..setAttribute('download', fileName)
      ..click();

    web.URL.revokeObjectURL(url);
  }
}
