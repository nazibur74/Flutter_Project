import 'dart:io';
import 'package:excel/excel.dart';

class ExportService {
  static Future<String> exportToExcel(
    String fileName,
    List<String> headers,
    List<List<dynamic>> data,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    sheet.appendRow(headers);

    for (var row in data) {
      sheet.appendRow(row);
    }

    // ✅ DIRECT DOWNLOAD PATH (NO PLUGIN NEEDED)
    final directory = Directory('/storage/emulated/0/Download');

    final folder = Directory('${directory.path}/Zstore');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final path = "${folder.path}/$fileName.xlsx";

    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return path;
  }
}
