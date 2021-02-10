import 'package:ReciboPDF/models/inquilino.dart';
import 'package:ReciboPDF/routes/app_routes.dart';
import 'package:flutter/material.dart';

class InquilinoTile extends StatelessWidget {
  final Inquilino _inquilino;
  const InquilinoTile(this._inquilino);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        title: Text(_inquilino.nome),
        subtitle: Text(
            '${_inquilino.endereco} - ${_inquilino.complemento} - ${_inquilino.cidade}'),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.PAGE_INQUILINO, arguments: _inquilino);
      },
    );
  }
}
