import 'package:ReciboPDF/pages/form_auth.dart';
import 'package:ReciboPDF/pages/form_inquilino.dart';
import 'package:ReciboPDF/pages/lista_inquilinos.dart';
import 'package:ReciboPDF/pages/page_inquilino.dart';
import 'package:ReciboPDF/provider/inquilinos.dart';
import 'package:ReciboPDF/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ReciboPDF());
}

class ReciboPDF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Inquilinos(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        title: "ReciboPDF",
        theme: ThemeData(primarySwatch: Colors.green),
        routes: {
          AppRoutes.FORM_AUTHENTICATION: (_) => FormAuth(),
          AppRoutes.FORM_INQUILINO: (_) => FormularioInquilino(),
          AppRoutes.LISTA_INQUILINOS: (_) => ListaInquilinos(),
          AppRoutes.PAGE_INQUILINO: (context) => PageInquilino(),
        },
      ),
    );
  }
}
