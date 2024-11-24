class OrderCalculationResponse {
  final double totalProductAmount;
  final double deliveryAmount;
  final double totalAmount;
  final String orderMessage;

  OrderCalculationResponse(this.totalProductAmount, this.deliveryAmount,
      this.totalAmount, this.orderMessage);

  factory OrderCalculationResponse.fromJson(Map<String, dynamic> json) =>
      OrderCalculationResponse(
        (json["products_amount"] as num).toDouble(),
        (json["delivery_amount"] as num).toDouble(),
        (json["payment_amount"] as num).toDouble(),
        json["order_message"],
      );
}
