import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';

class AddSupplierScreen extends StatefulWidget {
  final Supplier? supplier;

  AddSupplierScreen({this.supplier});

  @override
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final company = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  final service = SupplierService();

  @override
  void initState() {
    super.initState();

    if (widget.supplier != null) {
      name.text = widget.supplier!.name;
      company.text = widget.supplier!.company;
      phone.text = widget.supplier!.phone;
      address.text = widget.supplier!.address;
    }
  }

  void saveSupplier() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.supplier == null) {
      await service.insertSupplier(
        Supplier(
          name: name.text,
          company: company.text,
          phone: phone.text,
          address: address.text,
        ),
      );
    } else {
      await service.updateSupplier(
        Supplier(
          id: widget.supplier!.id,
          name: name.text,
          company: company.text,
          phone: phone.text,
          address: address.text,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Supplier saved successfully"),
        backgroundColor: Color(0xFF4A90E2),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCF5FF), // 🔵 same background

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1A3C5A)),
        title: Text(
          widget.supplier == null ? "Add Supplier" : "Update Supplier",
          style: TextStyle(
            color: Color(0xFF1A3C5A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 👤 HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.store,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        widget.supplier == null
                            ? "New Supplier"
                            : "Edit Supplier",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5A),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 📝 FIELDS
                  buildField(name, "Name", Icons.person),
                  SizedBox(height: 12),

                  buildField(company, "Company", Icons.business),
                  SizedBox(height: 12),

                  buildField(phone, "Phone", Icons.phone),
                  SizedBox(height: 12),

                  buildField(address, "Address", Icons.location_on),

                  SizedBox(height: 25),

                  // 🔥 ANIMATED BUTTON
                  AnimatedButton(
                    onTap: saveSupplier,
                    text: widget.supplier == null
                        ? "Add Supplier"
                        : "Update Supplier",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ INPUT FIELD WITH ICON + VALIDATION
  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      validator: (value) => value!.isEmpty ? "This field is required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF4A90E2)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;

  const AnimatedButton({required this.onTap, required this.text});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  double scale = 1.0;
  double opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      scale = 0.96;
      opacity = 0.85;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      scale = 1.0;
      opacity = 1.0;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      scale = 1.0;
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 120),
        opacity: opacity,
        child: AnimatedScale(
          duration: Duration(milliseconds: 120),
          scale: scale,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFF4A90E2),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
