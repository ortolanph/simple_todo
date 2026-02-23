import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:logging/logging.dart';
import 'package:simple_todo/data/todo.dart';
import 'package:simple_todo/utils/report_creator.dart';

class ExcelReportCreator implements ReportCreator {
  Logger logger = Logger("excel_report_creator");

  final CellStyle titleStyle = CellStyle(
    fontSize: 16,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
  );

  final CellStyle headerStyle = CellStyle(
    fontSize: 14,
    bold: true,
    horizontalAlign: HorizontalAlign.Center,
  );

  final CellStyle dataStyle = CellStyle(
    fontSize: 12,
    bold: false,
  );

  @override
  Future<Uint8List> generateReport(List<Todo> todos) async {
    logger.info("Generating Excel file");
    var excel = Excel.createExcel();

    logger.info("Getting default sheet");
    var sheet = excel.getDefaultSheet();
    logger.info("Sheet name: $sheet");

    logger.info("Generating title");
    TextCellValue titleCellValue = TextCellValue("Simple Todos");
    excel.appendRow(sheet!, [titleCellValue]);
    excel.merge(
        sheet, CellIndex.indexByString("A1"), CellIndex.indexByString("C1"));
    var titleCell = excel[sheet].cell(CellIndex.indexByString("A1"));
    titleCell.cellStyle = titleStyle;

    logger.info("Generating empty room");
    TextCellValue emptyCell = TextCellValue("");
    excel.appendRow(sheet, [emptyCell]);

    logger.info("Generating Headers");
    TextCellValue headerIdCellValue = TextCellValue("id");
    TextCellValue headerTodoCellValue = TextCellValue("Todo");
    TextCellValue headerDoneCellValue = TextCellValue("Done");

    excel.appendRow(sheet, [headerIdCellValue, headerTodoCellValue, headerDoneCellValue]);

    var headerIdCell = excel[sheet].cell(CellIndex.indexByString("A3"));
    headerIdCell.cellStyle = headerStyle;

    var headerTodoCell = excel[sheet].cell(CellIndex.indexByString("B3"));
    headerTodoCell.cellStyle = headerStyle;

    var headerDoneCell = excel[sheet].cell(CellIndex.indexByString("C3"));
    headerDoneCell.cellStyle = headerStyle;


    int rowIndex = 4;

    for (var todo in todos) {
      logger.info("Generating todo row $todo");
      excel.appendRow(sheet, [
        TextCellValue(todo.id),
        TextCellValue(todo.task),
        BoolCellValue(todo.done)
      ]);

      for (var letter in ["A", "B", "C"]) {
        var contentCellString = "$letter$rowIndex";
        var contentCell = excel[sheet].cell(CellIndex.indexByString(contentCellString));
        contentCell.cellStyle = dataStyle;
      }

      rowIndex++;
    }

    excel.rename(sheet, "TODOS");

    return Uint8List.fromList(excel.encode()!);
  }
}
