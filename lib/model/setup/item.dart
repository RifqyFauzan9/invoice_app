class Item {
  final String itemCode;
  final String itemName;

  Item({
    required this.itemCode,
    required this.itemName,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemCode: json['itemCode'],
      itemName: json['itemName'],
    );
  }
}

class InvoiceItem {
  final String item;
  final int itemQuantity;
  final int itemPrice;

  InvoiceItem({
    required this.item,
    required this.itemQuantity,
    required this.itemPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': item,
      'quantity': itemQuantity,
      'itemPrice': itemPrice,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      item: json['itemName'],
      itemQuantity: json['quantity'],
      itemPrice: json['itemPrice'],
    );
  }
}
