import 'package:flutter/material.dart';
import 'package:lebo/lebo.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: ListView(
        children: [
          MaterialButton(
            onPressed: () {
              snakBar(Lebo.instance.helpGuide);
            },
            child: Text(
              'HelpGuide',
            ),
          ),
          MaterialButton(
            onPressed: () {
              Lebo.instance.enableLog(enable: true);
            },
            child: Text(
              'enableLog',
            ),
          ),
          MaterialButton(
            onPressed: () async {
              bool result = await Lebo.instance.auth(
                appId: '',
                secretKey: '',
                error: (int? code, String? message) {
                  print('$code-----$message');
                },
              );
              print(result);
            },
            child: Text(
              'auth',
            ),
          ),
          MaterialButton(
            onPressed: () async {
              List? list = await Lebo.instance.getInterestsArray(
                error: (code, msg) {
                  print('$code-----$msg');
                },
              );
              print(list);
            },
            child: Text(
              'getInterestsArray',
            ),
          ),
        ],
      ),
    );
  }

  snakBar(String msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
