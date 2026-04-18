class Supplier {
  final int? id;
  final String name;
  final String company;
  final String phone;
  final String address;

  Supplier({
    this.id,
    required this.name,
    required this.company,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'company': company,
      'phone': phone,
      'address': address,
    };
  }
}
