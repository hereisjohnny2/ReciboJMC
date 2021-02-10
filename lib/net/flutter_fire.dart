import 'package:ReciboPDF/models/inquilino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

// ignore: missing_return
Future<bool> addInquilino(Inquilino inquilino) async {
  try {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('inquilinos').doc(inquilino.id);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        docRef.set({
          "nome": inquilino.nome,
          "endereco": inquilino.endereco,
          "complemento": inquilino.complemento,
          "cidade": inquilino.cidade,
          "valor_aluguel": inquilino.valorAluguel,
        });
        return true;
      }
      transaction.update(docRef, {
        "nome": inquilino.nome,
        "endereco": inquilino.endereco,
        "complemento": inquilino.complemento,
        "cidade": inquilino.cidade,
        "valor_aluguel": inquilino.valorAluguel,
      });
      return true;
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<bool> removeInquilino(String id) async {
  FirebaseFirestore.instance.collection('inquilinos').doc(id).delete();
  return true;
}
