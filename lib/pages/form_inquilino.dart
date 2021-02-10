import 'dart:math';

import 'package:ReciboPDF/models/inquilino.dart';
import 'package:ReciboPDF/net/flutter_fire.dart';
import 'package:flutter/material.dart';

class FormularioInquilino extends StatefulWidget {
  @override
  _FormularioInquilinoState createState() => _FormularioInquilinoState();
}

class _FormularioInquilinoState extends State<FormularioInquilino> {
  // Identifica o widget do formulário e permite a validação
  final _formKey = GlobalKey<FormState>();

  final Map<String, Object> _formData = {};
  String _titleLabel = "Novo Inquilino";

  void _loadFromData(Inquilino inquilino) {
    if (inquilino != null) {
      _formData['id'] = inquilino.id;
      _formData['Nome'] = inquilino.nome;
      _formData['Endereço'] = inquilino.endereco;
      _formData['Complemento'] = inquilino.complemento;
      _formData['Cidade'] = inquilino.cidade;
      _formData['Valor'] = inquilino.valorAluguel;
      setState(() {
        _titleLabel = "Editar Inquilino";
      });
    } else {
      _formData['id'] = Random().nextDouble().toString();
    }
  }

  @override
  void didChangeDependencies() {
    final Inquilino inquilino = ModalRoute.of(context).settings.arguments;
    _loadFromData(inquilino);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleLabel),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextFormField(
                  labelText: "Nome", inputType: TextInputType.name),
              buildTextFormField(
                  labelText: "Endereço", inputType: TextInputType.name),
              buildTextFormField(
                  labelText: "Complemento", inputType: TextInputType.name),
              buildTextFormField(
                  labelText: "Cidade", inputType: TextInputType.name),
              buildTextFormField(
                  labelText: "Valor", inputType: TextInputType.number),
              Container(
                width: 300.0,
                height: 50.0,
                child: ElevatedButton(
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () async {
                    _formKey.currentState.save();
                    await addInquilino(Inquilino(
                      id: _formData['id'],
                      nome: _formData['Nome'],
                      endereco: _formData['Endereço'],
                      complemento: _formData['Complemento'],
                      cidade: _formData['Cidade'],
                      valorAluguel: double.parse(_formData['Valor']),
                    ));
                    Navigator.of(context).pop();
                    // Provider.of<Inquilinos>(context, listen: false).put(
                    // Inquilino(
                    //   id: _formData['id'],
                    //   nome: _formData['Nome'],
                    //   endereco: _formData['Endereço'],
                    //   complemento: _formData['Complemento'],
                    //   cidade: _formData['Cidade'],
                    //   valorAluguel: double.parse(_formData['Valor']),
                    // ),
                    // );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildTextFormField({String labelText, Object inputType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue:
            _formData[labelText] == null ? "" : _formData[labelText].toString(),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
        validator: (value) {
          if (value.isEmpty) return 'Entre com algum valor!';
          return null;
        },
        onSaved: (value) => _formData[labelText] = value,
      ),
    );
  }
}
