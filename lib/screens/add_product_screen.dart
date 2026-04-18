import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/supplier.dart';
import '../services/product_service.dart';
import '../services/supplier_service.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final quantity = TextEditingController();

  final productService = ProductService();
  final supplierService = SupplierService();

  List<Supplier> suppliers = [];
  Supplier? selectedSupplier;

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  void loadSuppliers() async {
    final data = await supplierService.getAllSuppliers();
    setState(() {
      suppliers = data;
    });
  }

  void saveProduct() async {
    if (selectedSupplier == null) return;

    await productService.insertProduct(
      Product(
        name: name.text,
        supplierId: selectedSupplier!.id!,
        description: description.text,
        price: double.parse(price.text),
        quantity: int.parse(quantity.text),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCF5FF), // 🔵 FIXED

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1A3C5A)),
        title: Text(
          "Add Product",
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
            child: Column(
              children: [
                // 🏷 NAME
                buildField(name, "Product Name", Icons.inventory),
                SizedBox(height: 12),

                // 🔽 SUPPLIER DROPDOWN (UPDATED)
                DropdownButtonFormField<Supplier>(
                  value: selectedSupplier,
                  hint: Text("Select Supplier"),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.store, color: Color(0xFF4A90E2)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: suppliers.map((s) {
                    return DropdownMenuItem(value: s, child: Text(s.name));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSupplier = value;
                    });
                  },
                ),

                SizedBox(height: 12),

                buildField(description, "Description", Icons.description),
                SizedBox(height: 12),

                buildField(price, "Price", Icons.attach_money, isNumber: true),
                SizedBox(height: 12),

                buildField(quantity, "Quantity", Icons.numbers, isNumber: true),

                SizedBox(height: 25),

                // 🔥 ANIMATED BUTTON (CONSISTENT)
                AnimatedButton(onTap: saveProduct, text: "Add Product"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🎯 FIELD WITH ICON
  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
