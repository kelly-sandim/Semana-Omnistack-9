import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:json_table/json_table.dart';

class SimpleTable extends StatefulWidget {
  @override
  _SimpleTableState createState() => _SimpleTableState();
}

class _SimpleTableState extends State<SimpleTable> { 
  
  String idParceiro;
  var json;

  _loadId(callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    idParceiro = (prefs.getString('id_parceiro'));
    
    print("Inside Table.dart");
    print("id_parceiro: " + idParceiro);
    callback();
  }

  _buildJsonTable() async
  {
    final response = await http.post("http://app.vemrodar.com.br/app/listOperacao.php?id_parceiro="+idParceiro);
    var data = jsonDecode(response.body);
    //print(data);
    json = data['operacoes'];
    print(json);
    //jsonSample = response.body;
    //print("jsonSample: "+jsonSample);
  }

  @override
  void initState() {
    super.initState();
    _loadId(_buildJsonTable);
  }

  Widget build(BuildContext context) {
    //_buildJsonTable();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: 
            Column(
                children: [
                  JsonTable(
                    json,
                    //showColumnToggle: true,
                    tableHeaderBuilder: (String header) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            color: Colors.grey[300]),
                        child: Text(
                          header,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Colors.black87),
                        ),
                      );
                    },
                    tableCellBuilder: (value) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: Colors.grey.withOpacity(0.5))),
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display1.copyWith(
                              fontSize: 14.0, color: Colors.grey[900]),
                        ),
                      );
                    },
                    /*allowRowHighlight: true,
                    rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                    paginationRowCount: 4,*/
                  ),
                  
                ],
              )
             /*Center(
                child: Text(getPrettyJSONString(json)),
              ),*/
      ),
      /*floatingActionButton: FloatingActionButton(
          child: Icon(Icons.grid_on),
          onPressed: () {
            setState(
              () {
                toggle = !toggle;
              },
            );
          }),*/
    );
  }

  /*String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }*/
}