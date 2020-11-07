import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:work_pagination/model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'PaginationExample'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ConnectModel> connectModelList = [];

  @override
  void initState() {
    super.initState();
    getConnections(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: 400,
        child: FutureBuilder<ConnectModel>(
          future: getConnections(0),
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data.result.connect.length,
              itemBuilder: (_, index) {
                return Container(
                  height: 20,
                  child: Text(snapshot.data.result.connect[index].name),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<ConnectModel> getConnections(var offsetNumber) async {
    var uri = "http://campusx.herokuapp.com/api/v1/users/connect?$offsetNumber";
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI1ZjZhNDg4ZDJlYTkzNTAwMTdiZWM5YTEiLCJ1c2VyVGFnIjoiVG1haWluZS5jb2RlcyIsImNhbXB1cyI6IkJlbGxzIFVuaXZlcnNpdHkgT2YgVGVjaG5vbG9neSIsIm5hbWUiOiJUbWFpaW5lIiwiYXZhdGFyIjoiaHR0cHM6Ly9jYW1wdXN4LmFtczMuZGlnaXRhbG9jZWFuc3BhY2VzLmNvbS9hdmF0YXJzLzVmNmE0ODhkMmVhOTM1MDAxN2JlYzlhMSIsImlhdCI6MTYwMzM3MzE5M30.FfmGuemGz3Tm7pSo-PoLLbGS_nwx9olVk0ZBBDizDaw";
    try {
      final response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        return ConnectModel.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
