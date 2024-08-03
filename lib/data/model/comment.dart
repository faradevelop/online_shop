class CommentEntity {
  int? id;
  String? comment;
  int? rate;
  String? reply;
  String? date;
  String? user;

  CommentEntity({this.id, this.comment, this.rate, this.reply, this.date, this.user});

  CommentEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rate = json['rate'];
    reply = json['reply'];
    date = json['date'];
    user = json['user'];
  }


}