import 'dart:async';
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
  List<Connect> mainList = [];
  List<String> nameList = [];
  var offsetNumber;
  Future future;
  ScrollController _scrollController = new ScrollController();
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    offsetNumber = 0;
    future = getConnectionsList(offsetNumber);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          showLoader = true;
        });
        Timer(Duration(seconds: 2), () {
          setState(() {
            showLoader = false;
            offsetNumber = offsetNumber + 10;
            future = getConnectionsList(offsetNumber);
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: double.infinity,
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  controller: _scrollController,
                  itemCount: mainList.length,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 120,
                      child: Text(
                        nameList[index],
                        style: TextStyle(fontSize: 39),
                      ),
                    );
                  },
                )
                    // }),
                    ),
                if (showLoader)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Transform.scale(
                      scale: 1.0,
                      child: Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      )),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<List<Connect>> getConnectionsList(var offsetNumber) async {
    var uri = "http://campusx.herokuapp.com/api/v1/users/connect?$offsetNumber";
    var token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiI1ZjZhNDg4ZDJlYTkzNTAwMTdiZWM5YTEiLCJ1c2VyVGFnIjoiVG1haWluZS5jb2RlcyIsImNhbXB1cyI6IkJlbGxzIFVuaXZlcnNpdHkgT2YgVGVjaG5vbG9neSIsIm5hbWUiOiJUbWFpaW5lIiwiYXZhdGFyIjoiaHR0cHM6Ly9jYW1wdXN4LmFtczMuZGlnaXRhbG9jZWFuc3BhY2VzLmNvbS9hdmF0YXJzLzVmNmE0ODhkMmVhOTM1MDAxN2JlYzlhMSIsImlhdCI6MTYwMzM3MzE5M30.FfmGuemGz3Tm7pSo-PoLLbGS_nwx9olVk0ZBBDizDaw";
    try {
      final response =
          await http.get(uri, headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var d = data['result']['connectUsers'];
        for (var u in d) {
          Connect c = Connect.fromJson(u);
          mainList.add(c);
        }
        print("mainList $mainList");
        setState(() {
          nameList = mainList.map((e) => e.name).toList();
          print("nameList $nameList");
        });
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }
}
