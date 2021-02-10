import 'package:ReciboPDF/net/flutter_fire.dart';
import 'package:ReciboPDF/routes/app_routes.dart';
import 'package:flutter/material.dart';

class FormAuth extends StatefulWidget {
  @override
  _FormAuthState createState() => _FormAuthState();
}

class _FormAuthState extends State<FormAuth> {
  final _form = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Form(
        key: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                buildTextFormField(labelText: "Email", controller: _email),
                buildTextFormField(
                    labelText: "Senha", isPass: true, controller: _senha),
              ],
            ),
            buildAuthButton(),
          ],
        ),
      ),
    );
  }

  Container buildAuthButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 300.0,
      height: 80.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.white, onPrimary: Colors.green),
        child: Text(
          'Entrar',
          style: TextStyle(fontSize: 18.0),
        ),
        onPressed: () async {
          bool validate = _form.currentState.validate();
          if (!validate) {
            return;
          }
          bool continuar = await signIn(_email.text, _senha.text);
          if (continuar) {
            _email.text = "";
            _senha.text = "";
            Navigator.pushNamed(context, AppRoutes.LISTA_INQUILINOS);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Ops..."),
                  content: Text("Senha ou Email incorretos!"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"),
                    )
                  ],
                );
              },
            );
            _email.clear();
            _senha.clear();
          }
        },
      ),
    );
  }

  buildTextFormField(
      {String labelText,
      bool isPass = false,
      TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
            color: Colors.white, decorationStyle: TextDecorationStyle.solid),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
        ),
        obscureText: isPass,
        validator: (value) {
          if (value.isEmpty) return 'Entre com algum valor!';
          return null;
        },
      ),
    );
  }
}
