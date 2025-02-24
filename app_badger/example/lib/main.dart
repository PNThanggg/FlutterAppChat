import 'dart:developer';

import 'package:app_badger/app_badger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appBadgeSupported = 'Unknown';
  int _cnt = 1;

  @override
  initState() {
    super.initState();

    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    String appBadgeSupported;
    try {
      bool res = await AppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported = 'Supported';
      } else {
        appBadgeSupported = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported = 'Failed to get badge support.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _appBadgeSupported = appBadgeSupported;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Badge supported: $_appBadgeSupported\n'),
              TextButton(
                child: Text('Add badge'),
                onPressed: () {
                  _addBadge();
                },
              ),
              TextButton(
                  child: Text('Remove badge'),
                  onPressed: () {
                    _removeBadge();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _addBadge() {
    AppBadger.updateBadgeCount(_cnt);
    log("Count = $_cnt");
    _cnt += 1;
  }

  void _removeBadge() {
    AppBadger.removeBadge();
  }
}
