import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/relation.dart';
import 'models/relationship.dart';

class DatabaseHelper {
  final Database _db;
  static DatabaseHelper _instance;

  DatabaseHelper(this._db);

  static Future<DatabaseHelper> getInstance() async {
    if (_instance == null) _instance = await _initDatabase();
    return _instance;
  }

  static Future<DatabaseHelper> _initDatabase() async {
    var db = await openDatabase(join(await getDatabasesPath(), "lenden.db"),
        onCreate: (db, version) {
      Batch batch = db.batch();

      batch.execute(
        "CREATE TABLE relations(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
      );
      batch.execute(
        "CREATE TABLE relationships(id INTEGER PRIMARY KEY AUTOINCREMENT, amount INTEGER NOT NULL, comment TEXT NOT NULL, relation_id INTEGER, date STRING NOT NULL, FOREIGN KEY (relation_id) REFERENCES relations (id))",
      );

      return batch.commit();
    }, version: 1);

    return DatabaseHelper(db);
  }

  Future<void> insertRelation(Relation relation) async {
    await _db.insert('relations', relation.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<void> insertRelationship(Relationship relationship) async {
    await _db.insert('relationships', relationship.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<List<Relation>> getRelationList() async {
    List<Map<String, dynamic>> maps = await _db.query('relations');

    return List.generate(maps.length, (i) {
      return Relation(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  Future<List<Relationship>> getRelationshipList(int relationId) async {
    String whereString = 'relation_id = ?';

    List<Map<String, dynamic>> maps = await _db
        .query('relationships', where: whereString, whereArgs: [relationId]);

    List<Relationship> relationships = List.generate(maps.length, (i) {
      return Relationship(
          amount: maps[i]['amount'],
          relationId: maps[i]['relation_id'],
          comment: maps[i]['comment'],
          date: maps[i]['date']);
    });

    relationships.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    return relationships;
  }
}
