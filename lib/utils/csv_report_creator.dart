import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/utils/report_creator.dart';

class CsvReportCreator implements ReportCreator {
  Logger logger = Logger("csv_report_creator");

  @override
  Future<Uint8List> generateReport(List<Todo> todos) async {
    logger.info("Generating CSV");
    logger.info("Generating data");
    final data = todos.map((todo) => [todo.id, todo.task, todo.done]).toList();

    logger.info("Generating Header");
    data.insert(0, ["Id", "Task", "Done"]);

    return utf8.encode(csv.encode(data));
  }
}
