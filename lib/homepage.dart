import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenden/addrelation.dart';
import 'package:lenden/relationshiplist.dart';

import 'databasehelper.dart';
import 'models/relation.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  List<Relation> relationList;

  @override
  void initState() {
    super.initState();
    setRelationList();
  }

  void setRelationList() async {
    var db = await DatabaseHelper.getInstance();
    relationList = await db.getRelationList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Relations")),
        body: relationList != null
            ? _buildList()
            : Center(child: CircularProgressIndicator()),
        floatingActionButton: _buildFloatActionButton(context),
      );

  Widget _buildFloatActionButton(BuildContext context) => FloatingActionButton(
        heroTag: "Add Relation",
        onPressed: () async {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddRelation()));
          if (result == 1) {
            setState(() {
              relationList = null;
            });
            setRelationList();
          }
        },
        child: Icon(Icons.person),
      );

  Widget _buildList() => relationList.isEmpty
      ? Center(
          child: Text("No relation found in database",
              style: TextStyle(fontSize: 18)))
      : ListView.builder(
          itemCount: relationList.length,
          itemBuilder: (context, position) => Column(children: <Widget>[
                _buildListTile(context, position),
                Divider()
              ]));

  Widget _buildListTile(BuildContext context, int position) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text("${relationList[position].name}"),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RelationshipScreen(
                    relationList[position].id, relationList[position].name)));
      },
    );
  }
}
