import 'package:flutter/material.dart';

class Relation {
  final int id;
  final String name;

  Relation({this.id, @required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }
}
