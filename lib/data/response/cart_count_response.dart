class CartCountResponse{
  int? count;
  String? message;

  CartCountResponse({this.count, this.message});

  CartCountResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    message = json['message'];
  }


}