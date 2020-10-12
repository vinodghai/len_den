import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lenden/addrelationship.dart';
import 'package:lenden/edit_relationship.dart';
import 'package:lenden/models/relationship.dart';

import 'databasehelper.dart';

class RelationshipScreen extends StatefulWidget {
  @override
  State<RelationshipScreen> createState() => RelationshipScreenState();

  final int relationId;
  final String name;

  RelationshipScreen(this.relationId, this.name);
}

class RelationshipScreenState extends State<RelationshipScreen>
    implements ChangeRelationship {
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
            Expanded(child: RelationshipList(relationshipList, this))
          ],
        ),
      );

  String _calculateNet() {
    if (relationshipList == null) return "";

    int net = 0;
    for (Relationship r in relationshipList) {
      net += r.amount;
    }
    return NumberFormat().format(net);
  }

  @override
  void onChange() {
    _initRelationshipList();
  }
}

abstract class ChangeRelationship {
  void onChange();
}

class RelationshipList extends StatelessWidget {
  final List<Relationship> relationshipList;
  final ChangeRelationship deleteRelationship;

  RelationshipList(this.relationshipList, this.deleteRelationship);

  @override
  Widget build(BuildContext context) => relationshipList != null
      ? _buildList()
      : Center(child: CircularProgressIndicator());

  Widget _buildList() => relationshipList.isEmpty
      ? Center(
          child: Text("No relationship found in database",
              style: TextStyle(fontSize: 18)))
      : ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: relationshipList.length,
          itemBuilder: (context, position) =>
              _buildListItem(context, position));

  Widget _buildListItem(BuildContext context, int position) => Padding(
        padding: EdgeInsets.all(12.0),
        child: Slidable(
          actionExtentRatio: 0.15,
          actionPane: SlidableScrollActionPane(),
          secondaryActions: <Widget>[
            IconSlideAction(
              iconWidget: Icon(Icons.edit, color: Colors.white),
              color: Colors.grey,
              onTap: () async {
                final relationship = relationshipList[position];
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditRelationship(
                            relationship.id, relationship.relationId)));
                if (result == 1) deleteRelationship.onChange();
              },
            ),
            SlideAction(
              child: Icon(Icons.delete_outline, color: Colors.white),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4)),
                  color: Colors.redAccent),
              onTap: () async {
                final ref = await DatabaseHelper.getInstance();
                await ref.deleteRelationship(relationshipList[position].id);
                deleteRelationship.onChange();
              },
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFEBEDF9), width: 0.67),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0B000000),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: Offset(0, 1), // changes position of shadow
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(4)),
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
        ),
      );
}
