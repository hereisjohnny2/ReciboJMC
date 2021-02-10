import 'package:flutter/material.dart';

List _meses = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro'
];

List<DropdownMenuItem<String>> getDropDownMeses() {
  List<DropdownMenuItem<String>> meses = new List();
  for (var mes in _meses) {
    meses.add(
      new DropdownMenuItem(
        child: new Text(mes),
        value: mes,
      ),
    );
  }
  return meses;
}
