import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:teste_login/pages/QRReaderPage.dart';
//import 'package:teste_login/pages/QRPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste_login/pages/detalhesPage.dart';
import 'package:teste_login/pages/historicoPage.dart';
import 'package:teste_login/pages/powerPage.dart';
import 'package:teste_login/pages/userPage.dart';
import 'package:teste_login/pages/corridaPage.dart';
import 'package:http/http.dart' as http;


void main() => runApp(LoginApp());

String username;

class LoginApp extends StatelessWidget {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VemRodar',
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/powerPage': (BuildContext context) => new Power(),
        '/userPage': (BuildContext context) => new Usuarios(),
        '/LoginPage': (BuildContext context) => new LoginPage(),
        '/QRReaderPage' : (BuildContext context) => new QRReader(),
        '/HistoricoPage' : (BuildContext context) => new Historico(),
        '/CorridaPage' : (BuildContext context) => new Corrida(),
        '/DetalhesPage' : (BuildContext context) => new Detalhes(),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
/*
  String data;
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.json');
  }
  Future<String> readContent() async {
    /*try {
      final file = await _localFile;
      // Read the file
      String contents = await file.readAsString();
      // Returning the contents of the file
      return contents;
    } catch (e) {
      // If encountering an error, return
      return 'Error!';
    }*/
    final file = await _localFile;
    Stream<List<int>> inputStream = file.openRead();
      String line;
      inputStream
        .transform(utf8.decoder)       // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((line) {        // Process results.
            print('$line: ${line.length} bytes');
          },
          onDone: () { print('File is now closed.'); },
          onError: (e) { print(e.toString()); });
    return line;
  }

  Future<File> writeContent(var value) async {
    print("value passado: " + value);
    final file = await _localFile;
    // Write the file
    print(file);
    return file.writeAsString('$value');
  }
*/
  
  _addId(dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();    
    //_counter = (prefs.getInt('counter') ?? 0) + 1;
    prefs.setString('id_parceiro', value);
    print("id de parceiro pego: " + prefs.getString('id_parceiro'));    
  }


  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPass = new TextEditingController();

  String message = '';
  // Initially password is obscure
  bool _obscureText = true;
  //String _password;

// Toggles the password show status
  

void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erro!"),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }






Future<dynamic> _login() async {
    //final response = await http.get("http://app.vemrodar.com.br/app/auth.php?usuario="+controllerUser.text+"&senha="+controllerPass.text);
    final response = await http.post("http://app.vemrodar.com.br/app/auth.php?usuario="+controllerUser.text+"&senha="+controllerPass.text);
    //http.Response response = await http.get("http://app.vemrodar.com.br/app/auth.php?usuario="+controllerUser.text+"&senha="+controllerPass.text);
    /*final response = await http.post("http://192.168.10.166/login/login.php", body: {
      "username": controllerUser.text,
      "password": controllerPass.text,
    });*/
  

  //var datauser = json.decode(response.body);
    var datauser = json.decode(response.body);
    print(datauser);
    print(datauser['code']);
    print(datauser['message']);

    if(datauser['code'] == "error") {
      print("oi");
      setState(() {
        //message="Usuário ou senha incorretas";
        message=datauser['message'];
        _showDialog();
        //Navigator.pushReplacementNamed(context, '/LoginPage');
      });
    } else {
      //writeContent("id_parceiro: "+datauser['id']);
      //print("valor encontrado: " + data);
      _addId(datauser['id']);
      Navigator.pushReplacementNamed(context, '/QRReaderPage');      
    }
    /*
      if(datauser[0]['nivel']=='admin') {
        Navigator.pushReplacementNamed(context, '/powerPage');        
      } else if (datauser[0]['nivel']=='ventas') {
        Navigator.pushReplacementNamed(context,'/userPage');
      }
      setState((){
        username = datauser[0]['username'];
      });
    }*/
    //return datauser as Future<List>;
    return datauser;
  }

  @override
  /*void initState() {
    super.initState();
    //writeContent(value);
    readContent().then((String value) {
      setState(() {
        data = value;
      });
    });
  }*/
  



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      resizeToAvoidBottomPadding: false,
      body: Form(
        child: Container(
         // decoration: new BoxDecoration(
            //image: new DecorationImage(
            //image: new AssetImage("assets/images/lalala.jpg"),
            //fit BoxFit.cover
            //) // DecorationImage
          //), // BoxDecoration
          child: Column(
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(top: 90.0),
                padding: EdgeInsets.only(top: 77.0),
                child: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Image(
                    width: 135,
                    height: 135,
                    image: new AssetImage('assets/images/vemrodar.png'),
                  ),
                ),
                width: 170.0,
                height: 170.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                  top: 25
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 4
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5
                          )
                        ]
                      ),
                      child: TextFormField(
                        controller: controllerUser,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintText: 'Usuário'
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height:  50,
                      margin: EdgeInsets.only(
                        top: 32
                      ),
                      padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 4
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5 
                          )
                        ]
                      ),
                      child: TextField(
                        controller: controllerPass,
                        obscureText: _obscureText,                        
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.black,
                          ),
                          hintText: 'Senha',
                          suffixIcon: 
                            IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility,
                                semanticLabel: _obscureText ? "Show" : "Hide",  
                              ),
                              onPressed: () {
                                  setState(() {
                                    _obscureText ^= true;
                                  });
                              }),    
                          ),   
                        
                      ),
                      
                      
                      ),
                      /*Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 6,
                            right: 32,
                          ),
                          child: Text(
                            'Lembrar senha',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),*/ // Align
                    //Spacer(),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      child : new MaterialButton(
                        //padding: EdgeInsets.only(top: -10.0),
                        height: 50.0, 
                        child: new Text('Login', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                        color: Color(0xFF3F51B5),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                        ),
                        onPressed: (){
                          _login();
                        //Navigator.pop(context);
                        },
                      ),
                    /*Text(message,
                    style: TextStyle(fontSize: 15.0, color: Colors.red),)*/
                    ),
                  ],
                ),
              ),
            ], 
          ),
        ),
      ),      
    );
  }
}