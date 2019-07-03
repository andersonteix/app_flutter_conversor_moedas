import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const String request =
    "https://api.hgbrasil.com/finance?format=json&key=xxxxxxea9";
//const String request = "http://dadosabertos.almg.gov.br/ws/deputados/proposicoes/sumario?ini=20190101&fim=20191231&formato=json";

void main() async {
  http.Response response = await http.get(request);
//  print(response.body);
//  print(json.decode(response.body)['results']['currencies']['USD']);
//  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white
    ), // ThemeData
  )); // MaterialApp
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /** Controlador para armazenar texto digitado no campo */
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  /** variavel para armazena o valor de compra retornado da api */
  double dolar;
  double euro;

  /** função que recebe o texto digitado no momento em que é alterado*/
  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  /** Limpa os campos digitados */
  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor Monetário \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ), // AppBar
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ), // TextStyle
                  ), // Text
                ); // Center
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                        "Erro ao Carregar Ddos :(",
                        style: TextStyle(
                            color: Colors.amber, fontSize: 25.0
                        ), // TextStyle
                        ) // Text
                      ); // Center
                } else {

                  dolar = snapshot.data['results']['currencies']['USD']['buy'];
                  euro = snapshot.data['results']['currencies']['EUR']['buy'];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 150.0, color: Colors.amber
                        ), // Icon
                        buildTextField("Reais", "R\$ ", realController, _realChanged),
                        Divider(),
                        buildTextField("Dólares", "US\$ ", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€ ", euroController, _euroChanged),
                      ], // <Widget>[]
                    ), // Column
                  ); // SingleChildScrollView
                }
            } // switch
          }
          ), // FutureBuilder
    ); // Scaffold
  } // build
}

/* Função que cria TextFields dinamico*/
Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
   return TextField(
            controller: c,    // armazena texto inserido no campo
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.amber),
                border: OutlineInputBorder(),
                prefixText: prefix
            ), // InputDecoration
            style: TextStyle(
                color: Colors.amber, fontSize: 25.0
            ), // TextStyle
            onChanged: f,    // Envia o texto digitado no momento digitado
//            keyboardType: TextInputType.number,
            keyboardType: TextInputType.numberWithOptions(decimal: true), // tranforma o numero digitado em decimal
          ); // TextField
}
