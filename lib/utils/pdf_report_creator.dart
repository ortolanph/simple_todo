import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/utils/report_creator.dart';

class PdfReportCreator extends ReportCreator {
  Logger logger = Logger("pdf_report_creator");

  @override
  Future<Uint8List> generateReport(List<Todo> todos) {
    logger.info("Creating report");
    final pdf = pw.Document();

    logger.info("Total records: ${todos.length}");
    List<Todo> undone = todos.where((todo) => !todo.done).toList();
    logger.info("Selected records: ${undone.length}");

    logger.info("Creating document");
    try {
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
    } on Exception catch (exception) {
      logger.severe(exception);
    }

    return pdf.save();
  }

  pw.Widget _buildHeader() {
    logger.info("Creating header");
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
    logger.info("Creating task row");
    return pw.Container(
      child: pw.Padding(
        padding: pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Row(
          children: [
            pw.Container(
              width: 20,
              height: 20,
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                border: pw.Border.all(
                  color: PdfColors.black,
                  width: 1.5,
                ),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  todo.task,
                  style: pw.TextStyle(
                    fontSize: 10,
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Text(
                    todo.id,
                    style: pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
