import 'package:flutter/material.dart';
import 'package:lebo/lebo.dart';

void main() {
  runApp(MyApp());
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
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
                  appId: '18995',
                  secretKey: '2d7ff9ee669fbd2070d639e46b9a4515',
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
          ],
        ),
      ),
    );
  }
}
