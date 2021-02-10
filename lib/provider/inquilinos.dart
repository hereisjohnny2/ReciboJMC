import 'dart:math';
import 'package:ReciboPDF/models/inquilino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Inquilinos with ChangeNotifier {
  final _inquilinos = {};
  final _inquilinosCollection =
      FirebaseFirestore.instance.collection('inquilinos');

  List<Inquilino> get all {
    return [..._inquilinos.values];
  }

  CollectionReference get colRef {
    return _inquilinosCollection;
  }

  Inquilino byIndex(int index) {
    return _inquilinos.values.elementAt(index);
  }

  int get count {
    return _inquilinos.length;
  }

  void put(Inquilino inquilino) {
    if (inquilino == null) {
      return;
    }

    if (inquilino.id != null &&
        inquilino.id.trim().isNotEmpty &&
        _inquilinos.containsKey(inquilino.id)) {
      _inquilinos.update(
        inquilino.id,
        (_) => Inquilino(
          id: inquilino.id,
          nome: inquilino.nome,
          endereco: inquilino.endereco,
          complemento: inquilino.complemento,
          cidade: inquilino.cidade,
          valorAluguel: inquilino.valorAluguel,
        ),
      );
    } else {
      final id = Random().nextDouble().toString();
      _inquilinos.putIfAbsent(
        id,
        () => Inquilino(
          id: id,
          nome: inquilino.nome,
          endereco: inquilino.endereco,
          complemento: inquilino.complemento,
          cidade: inquilino.cidade,
          valorAluguel: inquilino.valorAluguel,
        ),
      );
    }

    notifyListeners();
  }

  void remove(Inquilino inquilino) {
    if (inquilino != null && inquilino.id != null) {
      _inquilinos.remove(inquilino.id);
    }
    notifyListeners();
  }
}
