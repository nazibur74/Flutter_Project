import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/product_service.dart';
import '../services/sales_service.dart';
import '../services/pdf_service.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final name = TextEditingController();
  final phone = TextEditingController();
  final quantityController = TextEditingController();

  final productService = ProductService();
  final salesService = SalesService();

  List<Product> products = [];
  List<CartItem> cart = [];

  Product? selectedProduct;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await productService.getAllProducts();
    setState(() => products = data);
  }

  void addToCart() {
    if (selectedProduct == null) return;

    setState(() {
      cart.add(CartItem(product: selectedProduct!, quantity: quantity));
    });

    quantityController.clear();
  }

  // ✅ FIX ADDED
  void removeFromCart(CartItem item) {
    setState(() {
      cart.remove(item);
    });
  }

  double getTotal() {
    double total = 0;
    for (var item in cart) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void saveSale() async {
    if (cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Cart is empty")));
      return;
    }

    await salesService.saveSale(name.text, phone.text, cart, getTotal());

    await PDFService.generateBill(name.text, phone.text, cart, getTotal());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sale Completed"),
        backgroundColor: Color(0xFF4A90E2),
      ),
    );

    setState(() {
      cart.clear();
      selectedProduct = null;
      quantity = 1;
    });

    name.clear();
    phone.clear();
    quantityController.clear();

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCF5FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sales",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF1A3C5A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCard(
                Column(
                  children: [
                    buildField(name, "Customer Name", Icons.person),
                    SizedBox(height: 12),

                    buildField(phone, "Phone", Icons.phone),
                    SizedBox(height: 12),

                    buildDropdown(),
                    SizedBox(height: 12),

                    buildField(
                      quantityController,
                      "Quantity",
                      Icons.numbers,
                      isNumber: true,
                      onChanged: (val) {
                        quantity = int.tryParse(val) ?? 1;
                      },
                    ),

                    SizedBox(height: 15),

                    AnimatedButton(onTap: addToCart, text: "Add to Cart"),
                  ],
                ),
              ),

              SizedBox(height: 15),

              buildCard(
                cart.isEmpty
                    ? Column(
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 5),
                          Text("Cart is empty"),
                        ],
                      )
                    : Column(
                        children: [...cart.map((item) => buildCartItem(item))],
                      ),
              ),

              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Total: ৳ ${getTotal().toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3C5A),
                  ),
                ),
              ),

              SizedBox(height: 10),

              AnimatedButton(onTap: saveSale, text: "Complete Sale"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: onChanged,
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

  Widget buildDropdown() {
    return DropdownButtonFormField<Product>(
      value: selectedProduct,
      hint: Text("Select Product"),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.inventory, color: Color(0xFF4A90E2)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: products.map((p) {
        return DropdownMenuItem(value: p, child: Text(p.name));
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedProduct = value;
        });
      },
    );
  }

  Widget buildCartItem(CartItem item) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.product.name)),
          Text("Qty: ${item.quantity}"),
          SizedBox(width: 10),
          Text("৳ ${(item.product.price * item.quantity).toStringAsFixed(2)}"),
          SizedBox(width: 10),

          // ❌ REMOVE BUTTON (ADDED ONLY)
          GestureDetector(
            onTap: () => removeFromCart(item),
            child: Icon(Icons.close, size: 20, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

// 🔥 BUTTON CLASS (UNCHANGED)
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
