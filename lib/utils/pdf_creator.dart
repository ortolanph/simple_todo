import 'package:pdf/widgets.dart' as pw;

import '../data/todo.dart';

Future<pw.Document> generatePDFReport(List<Todo> todos) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Center(
        child: pw.Container(
          padding: pw.EdgeInsets.all(10),
          child: pw.Column(
            children: [
              _buildHeader(),
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
