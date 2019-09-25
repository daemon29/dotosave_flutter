import 'dart:io';

import 'package:LadyBug/Customize/MultiLanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/lang.txt');
  }

  Future<File> writeLang(String lang) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(lang);
  }

  int _value;
  @override
  void initState() {
    _value = (setLanguage == 'vi') ? 2 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(captions[setLanguage]['setting']),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                captions[setLanguage]['language'],
              ),
              DropdownButton(
                  onChanged: (int change) {
                    setState(() {
                      setLanguage = (change == 1) ? 'en' : 'vi';
                      _value = change;
                    });
                    writeLang(setLanguage);
                  },
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      value: 1,
                      child: Text(captions[setLanguage]['english']),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(captions[setLanguage]['vietnamese']),
                    )
                  ])
            ],
          ),
        ));
  }
}
