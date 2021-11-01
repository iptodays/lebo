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
  List<LBLelinkService> list = [];

  @override
  void initState() {
    Lebo.instance
      ..logFileUploadCallback = logFileUploadCallback
      ..lelinkBrowserError = lelinkBrowserError
      ..lelinkBrowser = lelinkBrowser
      ..lelinkConnectionError = lelinkConnectionError
      ..lelinkConnection = lelinkConnection
      ..lelinkDisConnection = lelinkDisConnection
      ..lelinkPlayerError = lelinkPlayerError
      ..lelinkPlayer = lelinkPlayer
      ..lelinkPlayerStatus = lelinkPlayerStatus;
    super.initState();
  }

  logFileUploadCallback(
    bool result,
    String euqid,
    int? code,
    String? message,
  ) {
    print('code=$code, message=$message');
  }

  lelinkBrowserError(code, message) {
    print('code=$code, message=$message');
  }

  lelinkBrowser(List<LBLelinkService> services) {
    list = services;
    print(services.map((e) => e.lelinkServiceName).toList());
    setState(() {});
  }

  lelinkConnectionError(code, message) {
    print('LEBO-连接失败: code=$code, message=$message');
  }

  lelinkConnection(LBLelinkService service) {
    print('LEBO-连接成功: ${service.lelinkServiceName}');
    Lebo.instance.play(
      LBLelinkPlayerItem(
        mediaType: LBLelinkMediaType.videoOnline,
        mediaURLString: 'https://media.w3.org/2010/05/sintel/trailer.mp4',
        loopMode: LBLelinkMediaPlayLoopMode.defaul,
        mediaAssetType: LBPassthMediaAssetMediaType.longVideo,
      ),
    );
  }

  lelinkDisConnection(service) {}

  lelinkPlayerError(code, message) {
    print('code=$code, message=$message');
  }

  lelinkPlayer(progressInfo) {}

  lelinkPlayerStatus(status) {}

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
              await Lebo.instance.searchForLelinkService();
            },
            child: Text(
              'searchForLelinkService',
            ),
          ),
          MaterialButton(
            onPressed: () async {
              await Lebo.instance.stopSearch();
            },
            child: Text(
              'stopForLelinkService',
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
          Text('发现的设备'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              LBLelinkService model = list[index];
              return InkWell(
                onTap: () async {
                  await Lebo.instance.connect(model);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 56,
                  child: Text(
                    model.lelinkServiceName,
                  ),
                ),
              );
            },
            itemCount: list.length,
          )
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
