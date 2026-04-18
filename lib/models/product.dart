class Product {
  final int? id;
  final String name;
  final int supplierId;
  final String description;
  final double price;
  final int quantity;

  Product({
    this.id,
    required this.name,
    required this.supplierId,
    required this.description,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'supplier_id': supplierId,
      'description': description,
      'price': price,
      'quantity': quantity,
    };
  }
}
