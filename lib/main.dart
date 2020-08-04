import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'databasehelper.dart';
import 'homepage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.getInstance();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: Homepage(),
  ));
}
