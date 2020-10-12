import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenden/models/relationship.dart';

import 'databasehelper.dart';

class AddRelationship extends StatefulWidget {
  final int relationId;

  AddRelationship(this.relationId);

  @override
  State<AddRelationship> createState() => AddRelationshipState();
}

class AddRelationshipState extends State<AddRelationship> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final dateController =
      TextEditingController(text: DateTime.now().toString().split(" ")[0]);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Add Relationship")),
        body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                // Add TextFormFields and RaisedButton here.
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(signed: true),
                  decoration: InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: "Amount",
                  ),
                  validator: (String value) =>
                      value.isEmpty ? "Please enter amount" : null,
                ),
                SizedBox(height: 16.0),

                MyDatePicker(dateController),
                SizedBox(height: 16.0),

                TextFormField(
                  controller: commentController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.comment),
                    labelText: "Comment",
                  ),
                  validator: (String value) =>
                      value.isEmpty ? "Please enter comment" : null,
                ),
                SizedBox(height: 16.0),

                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final ref = await DatabaseHelper.getInstance();
                      await ref.insertRelationship(Relationship(
                          amount: int.parse(amountController.text),
                          date: dateController.text,
                          comment: commentController.text,
                          relationId: widget.relationId));
                      Navigator.pop(context, 1);
                    }
                  },
                  child: Text('Add'),
                )
              ]),
            )),
      );

  final commentController = TextEditingController();
}

class MyDatePicker extends StatefulWidget {
  final TextEditingController controller;

  MyDatePicker(this.controller);

  @override
  State<MyDatePicker> createState() => MyDatePickerState();
}

class MyDatePickerState extends State<MyDatePicker> {
  @override
  Widget build(BuildContext context) => TextFormField(
        readOnly: true,
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(Icons.date_range),
          labelText: "Date",
        ),
        validator: (String value) => value.isEmpty ? "Please enter date" : null,
        keyboardType: TextInputType.datetime,
        onTap: () async {
          DateTime date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030));

          if (date != null)
            setState(() {
              widget.controller.text = date.toString().split(" ")[0];
            });
        },
      );
}
