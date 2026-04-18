class Sale {
  final int? id;
  final String customerName;
  final String phone;
  final String date;
  final double total;

  Sale({
    this.id,
    required this.customerName,
    required this.phone,
    required this.date,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'phone': phone,
      'date': date,
      'total_amount': total,
    };
  }
}
