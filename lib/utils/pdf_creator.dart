import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/todo.dart';

Future<pw.Document> generatePDFReport(List<Todo> todos) async {
  final pdf = pw.Document();

  List<Todo> undone = todos.where((todo) => !todo.done).toList();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Container(
          padding: pw.EdgeInsets.all(10),
          child: pw.Column(
            children: [
              _buildHeader(),
              pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Column(
                    children: List.generate(
                      undone.length,
                      (u) => _buildTaskRow(undone[u]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  return pdf;
}

pw.Widget _buildHeader() {
  return pw.Container(
    padding: pw.EdgeInsets.all(10),
    child: pw.Text(
      "Simple TODO List",
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
      ),
    ),
  );
}

pw.Widget _buildTaskRow(Todo todo) {
  return pw.Container(
    child: pw.Row(
      children: [
        pw.Container(
          width: 10,
          height: 10,
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            border: pw.Border.all(
              color: PdfColors.black,
              width: 1.5,
            ),
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Text(todo.task),
      ],
    ),
  );
}
