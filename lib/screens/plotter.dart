import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:npsh/providers/npsh.dart';
import 'package:npsh/widgets/chart.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class Plotter extends StatefulWidget {
  const Plotter({super.key});

  @override
  State<Plotter> createState() => _PlotterState();
}

class _PlotterState extends State<Plotter> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<void> _handleSave(BuildContext context) async {
    await _pdfResults(context);
  }

  Future _pdfResults(context) async {
    var pdf = pw.Document();
    final bytes = await screenshotController.capture();

    final NpshProvider npshProvider =
        Provider.of<NpshProvider>(context, listen: false);

    final bool showTable = npshProvider.marca != "" &&
        npshProvider.serie != "" &&
        npshProvider.potencia != 0;

    const tableHeaders = ['Bomba ensayada', ''];

    final dataTable = [
      ['Marca', npshProvider.marca],
      ['Serie', npshProvider.serie],
      ['Potencia (hp)', npshProvider.potencia],
    ];

    final ByteData image = await rootBundle.load('images/ues_logo.jpg');
    Uint8List imageData = (image).buffer.asUint8List();

    final table = pw.TableHelper.fromTextArray(
      border: null,
      headers: tableHeaders,
      data: List<List<dynamic>>.generate(
        dataTable.length,
        (index) => <dynamic>[
          dataTable[index][0],
          dataTable[index][1],
        ],
      ),
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColors.black,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      cellAlignment: pw.Alignment.centerRight,
      cellAlignments: {0: pw.Alignment.centerLeft},
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        margin: const pw.EdgeInsets.all(64),
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
              children: [
                pw.Row(children: [
                  pw.SizedBox(
                      width: 60,
                      height: 60,
                      child: pw.Image(pw.MemoryImage(imageData))),
                  pw.SizedBox(width: 20),
                  pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "UNIVERSIDAD DE EL SALVADOR",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "FACULTAD DE INGENIERÍA Y ARQUITECTURA",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "ESCUELA DE INGENIERÍA MECÁNICA",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "DEPARTAMENTO DE SISTEMAS FLUIDOMECÁNICOS",
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ])
                ]),
                pw.SizedBox(height: 20),
                showTable ? table : pw.SizedBox(height: 0),
                //divider with line and padding
                pw.SizedBox(height: 20),
                pw.Divider(
                  thickness: 1,
                  color: PdfColors.grey200,
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    "Curva NPSH3 vs Q",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Container(
                    height: 700,
                    width: 1080,
                    child: pw.Expanded(
                      child: pw.Image(pw.MemoryImage(bytes!)),
                    ),
                  ),
                ),
                pw.SizedBox(height: 110),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Reporte: NPSH3",
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      DateTime.now().toString(),
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );
    await savePdf(pdf, context);
  }

  Future<String> savePdf(pw.Document pdf, var context) async {
    late File file;

    file = File("best_pdf.pdf");

    if (await file.exists()) {
      try {
        await file.delete();
      } on Exception catch (e) {
        print(e);
      }
    }

    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Guarda tu archivo',
        fileName: "npsh_test",
        allowedExtensions: [
          'pdf',
        ]);

    try {
      File returnedFile = File('$outputFile.pdf');
      await returnedFile.writeAsBytes(await pdf.save());
    } catch (e) {}

    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfica NPSH3 vs Q'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleSave(context);
        },
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // margin: const EdgeInsets.only(bottom: 200),
              child: Screenshot(
                  controller: screenshotController, child: LineChartSample4()),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
