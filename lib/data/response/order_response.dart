class OrderResponse {
  String? message;
  String? paymentLink;

  OrderResponse({this.message, this.paymentLink});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? "";
    paymentLink = json['payment_link'] ?? "";
  }
}
