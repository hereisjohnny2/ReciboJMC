import 'dart:io';
import 'package:ReciboPDF/models/inquilino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

Future<pw.Document> generatePDF({Inquilino inquilino, String mes}) async {
  final pdf = pw.Document();

  final logo = pw.MemoryImage(
    (await rootBundle.load('lib/assets/imagens/logo.jpg')).buffer.asUint8List(),
  );
  final assinatura = pw.MemoryImage(
    (await rootBundle.load('lib/assets/imagens/assinatura.png'))
        .buffer
        .asUint8List(),
  );

  String endereco =
      "${inquilino.endereco} - ${inquilino.complemento} - ${inquilino.cidade}";

  String reciboTexto =
      "Recebi de ${inquilino.nome} a importância de R\$${inquilino.valorAluguel.toStringAsFixed(2)}, em dinheiro, referente ao pagamento de sua mensalidade locatícia do mês de $mes, relativo ao imóvel localizado na $endereco.";

  DateTime dataAtual = DateTime.now();
  String data =
      DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(dataAtual);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a3,
      margin: pw.EdgeInsets.all(16),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Container(
            child: pw.Image.provider(logo),
          ),
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: <pw.Widget>[
                pw.Text("RECIBO DE ALUGUEL DE IMÓVEL RESIDENCIAL")
              ],
            ),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 16.0),
            child: pw.Paragraph(
                text: reciboTexto, style: pw.TextStyle(fontSize: 16.0)),
          ),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 16.0),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Column(
                  children: [
                    pw.Paragraph(
                      text: "Rio das Ostras, $data",
                      textAlign: pw.TextAlign.right,
                    ),
                    pw.Container(
                      child: pw.Image.provider(assinatura, width: 150),
                    ),
                    pw.Paragraph(
                      text: "JMC",
                      style: pw.TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];
      },
    ),
  );
  return pdf;
}

Future savePdf({Inquilino inquilino, String mes}) async {
  final pdf = await generatePDF(inquilino: inquilino, mes: mes);
  Directory diretorio = await getApplicationDocumentsDirectory();
  String path = diretorio.path;
  File arquivo = File("$path/recibo_${inquilino.nome}_$mes.pdf");
  arquivo.writeAsBytes(pdf.save());
}

class PDFViewer extends StatelessWidget {
  const PDFViewer({
    Key key,
    @required this.pathCompleto,
  }) : super(key: key);

  final String pathCompleto;

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text("Recibo PDF"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.shareFiles(['$pathCompleto'], text: 'Teste PDF');
            },
          )
        ],
      ),
      path: pathCompleto,
    );
  }
}
