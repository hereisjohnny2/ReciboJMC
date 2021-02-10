import 'package:ReciboPDF/components/inquilino_tile.dart';
import 'package:ReciboPDF/models/inquilino.dart';
import 'package:ReciboPDF/routes/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListaInquilinos extends StatefulWidget {
  @override
  _ListaInquilinosState createState() => _ListaInquilinosState();
}

class _ListaInquilinosState extends State<ListaInquilinos> {
  List<Inquilino> _inquilinos = [];
  List<Inquilino> _inquilinosFiltrados = [];
  TextEditingController searchController = TextEditingController();
  String filtro = "";
  Icon icone = new Icon(Icons.search);
  Widget appBarTitle = new Text("Inquilinos");

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          filtro = "";
          _inquilinosFiltrados = _inquilinos;
        });
      } else {
        setState(() {
          filtro = searchController.text;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _inquilinos = Provider.of<Inquilinos>(context);
    return Scaffold(
      appBar: AppBar(
        title: appBarTitle,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: icone,
            onPressed: () {
              setState(() {
                if (this.icone.icon == Icons.search) {
                  this.icone = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    controller: searchController,
                    decoration: new InputDecoration(
                      prefixIcon: new Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Buscar...",
                      hintStyle: new TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                  );
                } else {
                  this.icone = new Icon(Icons.search);
                  this.appBarTitle = new Text("Inquilinos");
                  _inquilinosFiltrados = _inquilinos;
                  searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              buildExitDialog(context).then((confirmed) {
                if (confirmed) {
                  Navigator.of(context).pop();
                }
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('inquilinos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          _inquilinos = snapshot.data.docs.map((document) {
            return Inquilino(
              id: document.id,
              nome: document.data()['nome'],
              endereco: document.data()['enderco'],
              complemento: document.data()['complemento'],
              cidade: document.data()['cidade'],
              // valorAluguel: double.parse(document.data()['valor_aluguel'].toString()),
              valorAluguel:
                  double.tryParse(document.data()['valor_aluguel'].toString()),
            );
          }).toList();

          _inquilinos.sort((a, b) {
            return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
          });

          _inquilinosFiltrados = _inquilinos;
          if ((filtro.isNotEmpty)) {
            List<Inquilino> tmpLista = [];
            _inquilinosFiltrados.forEach((inquilino) {
              if (inquilino.nome.toLowerCase().contains(filtro.toLowerCase())) {
                tmpLista.add(inquilino);
              }
            });
            _inquilinosFiltrados = tmpLista;
          }

          return ListView.separated(
            itemCount: _inquilinosFiltrados.length,
            itemBuilder: (context, index) {
              return InquilinoTile(_inquilinosFiltrados.elementAt(index));
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
          // return ListView.builder(
          //   itemCount: _inquilinos.count,
          //   itemBuilder: (context, index) {
          //     return InquilinoTile(_inquilinos.byIndex(index));
          //   },
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.FORM_INQUILINO);
        },
      ),
    );
  }

  Future buildExitDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sair"),
        content: Text("Tem Certeza?"),
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
}
