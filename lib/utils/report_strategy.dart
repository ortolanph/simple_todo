import 'package:simple_todo/utils/csv_report_creator.dart';
import 'package:simple_todo/utils/excel_report_creator.dart';
import 'package:simple_todo/utils/pdf_report_creator.dart';
import 'package:simple_todo/utils/report_creator.dart';

enum ReportType {
  pdf(mimeType: "application/pdf", extension: "pdf"),
  csv(mimeType: "text/csv", extension: "csv"),
  excel(
      mimeType:
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      extension: "xlsx");

  const ReportType({required this.mimeType, required this.extension});

  final String mimeType;
  final String extension;
}

class ReportStrategy {
  ReportCreator getReportCreator(ReportType reportType) {
    return switch (reportType) {
      ReportType.pdf => PdfReportCreator(),
      ReportType.csv => CsvReportCreator(),
      ReportType.excel => ExcelReportCreator(),
    };
  }
}
