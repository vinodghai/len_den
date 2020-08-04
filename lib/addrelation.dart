import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenden/models/relation.dart';

import 'databasehelper.dart';

class AddRelation extends StatefulWidget {
  @override
  State<AddRelation> createState() => AddRelationState();
}

class AddRelationState extends State<AddRelation> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Add Reation")),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                // Add TextFormFields and RaisedButton here.
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Relation name",
                  ),
                  validator: (String value) =>
                      value.isEmpty ? "Please enter relation name" : null,
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final reference = await DatabaseHelper.getInstance();
                      await reference
                          .insertRelation(Relation(name: nameController.text));
                      Navigator.pop(context, 1);
                    }
                  },
                  child: Text('Submit'),
                )
              ]),
            )),
      );
}
