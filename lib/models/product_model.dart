class ProductModel {
  final String? code;
  final String? name;
  final int? qty;
  final String? productId;
  ProductModel({
    this.code,
    this.name,
    this.qty,
    this.productId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      qty: json['qty'] ?? 0,
      productId: json['productId'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'code': code,
      'name': name,
      'qty': qty,
      'productId': productId,
    };
  }
}
