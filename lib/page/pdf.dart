import 'dart:io';

import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generateDevicePdf(String model, String serialNumber,
    String deviceCode, String productDesc) async {
  var myTheme = pw.ThemeData.withFont(
    base:
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
    bold: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
    italic:
        pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
    boldItalic: pw.Font.ttf(
        await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")),
  );

  final doc = pw.Document(
    theme: myTheme,
  );
  PdfPageFormat format =
      const PdfPageFormat(PdfPageFormat.inch * 3, PdfPageFormat.inch * 1);
  doc.addPage(pw.Page(
      pageFormat: format,
      build: (pw.Context context) {
        return pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: <pw.Widget>[
                  pw.BarcodeWidget(
                      width: 50,
                      height: 50,
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: productDesc),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(model,
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(serialNumber,
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold)),
                          pw.Text(productDesc,
                              style: pw.TextStyle(
                                  fontSize: 10, fontWeight: pw.FontWeight.bold))
                        ]),
                  )
                ]));
      }));

  List<int> d = await doc.save();
  final path = (await getExternalStorageDirectory())?.path ?? "";
  final file = File("$path/$deviceCode.pdf");
  await file.writeAsBytes(d, flush: true);
  OpenFile.open(file.path);
}
