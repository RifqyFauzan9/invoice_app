class InvoiceItem {
  final Item item;
  final int quantity;
  final int itemPrice;

  InvoiceItem({
    required this.item,
    required this.quantity,
    required this.itemPrice,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
    item: Item.fromJson(json["item"]),
    quantity: json["quantity"],
    itemPrice: json["itemPrice"],
  );

  Map<String, dynamic> toJson() => {
    "item": item.toJson(),
    "quantity": quantity,
    "itemPrice": itemPrice,
  };
}

class Item {
  final String itemName;
  final String itemCode;

  Item({
    required this.itemName,
    required this.itemCode,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    itemName: json["itemName"],
    itemCode: json["itemCode"],
  );

  Map<String, dynamic> toJson() => {
    "itemName": itemName,
    "itemCode": itemCode,
  };
}