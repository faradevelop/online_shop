class ProductEntity {
  int? id;
  String? title;
  String? image;
  String? price;
  String? realPrice;
  String? description;

  //List<String>? gallery;
  int? discountPercent;
  String? category;
  int? reviewsCount;
  bool? bookmarked;
  int? cartCount;

  ProductEntity(
      {this.id,
      this.title,
      this.image,
      this.price,
      this.realPrice,
      this.description,
      //this.gallery,
      this.discountPercent,
      this.category,
      this.reviewsCount,
      this.bookmarked,
      this.cartCount});

  ProductEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    price = json['price'];
    realPrice = json['real_price'];
    description = json['description'];
    //gallery = json['gallery'].cast<String>();
    discountPercent = json['discount_percent'];
    category = json['category'];
    reviewsCount = json['reviews_count'];
    bookmarked = json['bookmarked'];
    cartCount = json['cart_count'];
  }
}

class Sort {
  final int id;
  final String orderBy;
  final String orderType;
  final String txt;

  Sort(
      {required this.id, required this.orderBy, required this.orderType, required this.txt});
}
