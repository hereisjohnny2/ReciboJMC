import 'dart:io';
import 'package:ReciboPDF/components/meses_dropdown.dart';
import 'package:ReciboPDF/data/pdf_generation.dart';
import 'package:ReciboPDF/net/flutter_fire.dart';
import 'package:flutter/material.dart';
import 'package:ReciboPDF/models/inquilino.dart';
import 'package:ReciboPDF/routes/app_routes.dart';
import 'package:path_provider/path_provider.dart';

class PageInquilino extends StatefulWidget {
  @override
  _PageInquilinoState createState() => _PageInquilinoState();
}

class _PageInquilinoState extends State<PageInquilino> {
  List<DropdownMenuItem<String>> _dropDownMeses;
  String _mesAtual;

  @override
  void initState() {
    _dropDownMeses = getDropDownMeses();
    changeDropDownMes(_dropDownMeses[0].value);
    super.initState();
  }

  void changeDropDownMes(String mesSelecionado) {
    setState(() {
      _mesAtual = mesSelecionado;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Inquilino inquilino = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados do Inquilino'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              buildRemoveDialogBox(context).then(
                (confirmed) async {
                  if (confirmed) {
                    // Provider.of<Inquilinos>(context, listen: false)
                    //     .remove(inquilino);
                    await removeInquilino(inquilino.id);
                    Navigator.of(context).pop();
                  }
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildInfo(inquilino.nome, 26.0),
                buildInfo(
                    '${inquilino.endereco} - ${inquilino.complemento} - ${inquilino.cidade}',
                    18.0),
                buildInfo(
                    'R\$${inquilino.valorAluguel.toStringAsFixed(2)}', 21.0),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                  items: _dropDownMeses,
                  value: _mesAtual,
                  onChanged: changeDropDownMes,
                ),
                ElevatedButton(
                  child: Text("Gerar Recibo"),
                  onPressed: () async {
                    await savePdf(inquilino: inquilino, mes: _mesAtual);
                    Directory dir = await getApplicationDocumentsDirectory();
                    String documentPath = dir.path;
                    String pathCompleto =
                        "$documentPath/recibo_${inquilino.nome}_$_mesAtual.pdf";
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PDFViewer(pathCompleto: pathCompleto);
                    }));
                  },
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.FORM_INQUILINO, arguments: inquilino);
        },
      ),
    );
  }

  Future buildRemoveDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Apagar Inquilino"),
        content: Text("Essa ação será permanente, tem certeza?"),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Não"),
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("Sim"),
          ),
        ],
      ),
    );
  }

  Padding buildInfo(String info, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(info, style: TextStyle(fontSize: size)),
    );
  }
}
