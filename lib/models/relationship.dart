class Relationship {

  final int id;
  final int relationId;
  final int amount;
  final String date;
  final String comment;

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'date': date,
      'comment': comment,
      'relation_id': relationId
    };
  }

  Relationship({this.id, this.relationId, this.amount, this.date, this.comment});
}
