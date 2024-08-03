

class CategoryEntity {
  int? id;
  String? title;
  String? image;

  CategoryEntity({this.id, this.title, this.image});

  CategoryEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
  }

}
