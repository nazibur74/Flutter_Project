class Employee {
  final int? id;
  final String name;
  final String dob;
  final String phone;
  final String email;
  final String nid;
  final String role;
  final String address;

  Employee({
    this.id,
    required this.name,
    required this.dob,
    required this.phone,
    required this.email,
    required this.nid,
    required this.role,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'phone': phone,
      'email': email,
      'nid': nid,
      'role': role,
      'address': address,
    };
  }
}
