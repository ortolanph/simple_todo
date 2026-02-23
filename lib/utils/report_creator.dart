import 'dart:typed_data';

import '../data/todo.dart';

abstract class ReportCreator {
  Future<Uint8List> generateReport(List<Todo> todos);
}