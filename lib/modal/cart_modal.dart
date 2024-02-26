class Cart {
  int? id;
  String? productId;
  String? productName;
  int? initialValue;
  int? totalProductPrice;
  int? quantity;
  String? unitTag;
  String? images;

  Cart(
      {this.id,
      required this.productId,
      required this.productName,
      required this.initialValue,
      required this.totalProductPrice,
      required this.quantity,
      required this.images,
      required this.unitTag});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['productId'] = productId;
    map['productName'] = productName;
    map['initialValue'] = initialValue;
    map['totalProductPrice'] = totalProductPrice;
    map['quantity'] = quantity;
    map['unitTag'] = unitTag;
    map['images'] = images;
    return map;
  }

  Cart.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    productId = map['productId'];
    productName = map['productName'];
    initialValue = map['initialValue'];
    totalProductPrice = map['totalProductPrice'];
    quantity = map['quantity'];
    unitTag = map['unitTag'];
    images = map['images'];
  }
}
