import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenden/addrelationship.dart';
import 'package:lenden/models/relationship.dart';

import 'databasehelper.dart';

class RelationshipScreen extends StatefulWidget {
  @override
  State<RelationshipScreen> createState() => RelationshipScreenState();

  final int relationId;
  final String name;

  RelationshipScreen(this.relationId, this.name);
}

class RelationshipScreenState extends State<RelationshipScreen> {
  List<Relationship> relationshipList;

  @override
  void initState() {
    super.initState();
    _initRelationshipList();
  }

  void _initRelationshipList() async {
    var ref = await DatabaseHelper.getInstance();
    relationshipList = await ref.getRelationshipList(widget.relationId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Relationships")),
        floatingActionButton: FloatingActionButton(
          heroTag: "Add a Relationship",
          onPressed: () async {
            final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddRelationship(widget.relationId)));

            if (result == 1) {
              setState(() {
                relationshipList = null;
              });
              _initRelationshipList();
            }
          },
          child: Icon(Icons.attach_money),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 16.0),
            Text("${widget.name}", style: TextStyle(fontSize: 22.0)),
            SizedBox(height: 12.0),
            Text("Net: ${_calculateNet()}", style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 16.0),
            Expanded(
                child: RelationshipList(widget.relationId, relationshipList))
          ],
        ),
      );

  String _calculateNet() {
    if (relationshipList == null)
      return "";

    int net = 0;
    for (Relationship r in relationshipList) {
      net += r.amount;
    }
    return NumberFormat().format(net);
  }
}

class RelationshipList extends StatelessWidget {
  final int relationId;
  final List<Relationship> relationshipList;

  RelationshipList(this.relationId, this.relationshipList);

  @override
  Widget build(BuildContext context) => relationshipList != null
      ? _buildList()
      : Center(child: CircularProgressIndicator());

  Widget _buildList() => relationshipList.isEmpty
      ? Center(
          child: Text("No relationship found in database",
              style: TextStyle(fontSize: 18)))
      : ListView.builder(
          itemCount: relationshipList.length,
          itemBuilder: (context, position) => _buildListItem(position));

  Widget _buildListItem(int position) => Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(
                            "Rs. ${NumberFormat().format(relationshipList[position].amount)}",
                            style: TextStyle(fontSize: 20))),
                    Expanded(
                        child: Text(
                            "${DateFormat("dd-MMM-yy").format(DateTime.parse(relationshipList[position].date))}",
                            style: TextStyle(fontSize: 18))),
                  ],
                ),
                Padding(
                    child: Divider(),
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text("${relationshipList[position].comment}",
                    style: TextStyle(fontSize: 16.0))
              ],
            ),
          ),
        ),
      );
}
