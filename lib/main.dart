import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'dart:convert';

const String request =
    "https://api.hgbrasil.com/finance?format=json&key=61615ea9";
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
  double dolar;
  double euro;

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
                            size: 150.0, color: Colors.amber),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "R\$ "
                          ), // InputDecoration
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0), // TextStyle
                        ), // TextField
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Dólares",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "US\$ "
                          ), // InputDecoration
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0), // TextStyle
                        ), // TextField
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Euros",
                              labelStyle: TextStyle(color: Colors.amber),
                              border: OutlineInputBorder(),
                              prefixText: "€\$ "
                          ), // InputDecoration
                          style: TextStyle(
                              color: Colors.amber, fontSize: 25.0), // TextStyle
                        ) // TextField
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
