import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import 'add_product_screen.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService service = ProductService();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final data = await service.getAllProducts();
    setState(() {
      products = data;
    });
  }

  void goToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddProductScreen()),
    );

    if (result == true) loadProducts();
  }

  void deleteProduct(int id) async {
    await service.deleteProduct(id);
    loadProducts();
  }

  void confirmDelete(Product p) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete ${p.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteProduct(p.id!);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCF5FF), // 🔵 same theme

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Products",
          style: TextStyle(
            color: Color(0xFF1A3C5A),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),

      body: Column(
        children: [
          // 📋 LIST
          Expanded(
            child: products.isEmpty
                ? Center(child: Text("No products yet"))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // 📦 PRODUCT ICON
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.inventory,
                                size: 40,
                                color: Color(0xFF4A90E2),
                              ),
                            ),

                            SizedBox(width: 12),

                            // 📋 INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // NAME
                                  Text(
                                    p.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1A3C5A),
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  // DESCRIPTION
                                  Text(
                                    p.description,
                                    style: TextStyle(color: Colors.black54),
                                  ),

                                  SizedBox(height: 8),

                                  // PRICE + STOCK
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Price: ${p.price}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1A3C5A),
                                        ),
                                      ),

                                      Text(
                                        "Stock: ${p.quantity}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: p.quantity < 5
                                              ? Colors.redAccent
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // 🗑 DELETE
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.black54),
                              onPressed: () => confirmDelete(p),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // 🔥 ANIMATED BUTTON
          Padding(
            padding: EdgeInsets.all(12),
            child: AnimatedButton(
              onTap: goToAddProduct,
              text: "Add New Product",
            ),
          ),
        ],
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
