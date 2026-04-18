import 'package:flutter/material.dart';
import '../models/supplier.dart';
import '../services/supplier_service.dart';
import 'add_supplier_screen.dart';

class SupplierScreen extends StatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final SupplierService service = SupplierService();
  List<Supplier> suppliers = [];

  @override
  void initState() {
    super.initState();
    loadSuppliers();
  }

  void loadSuppliers() async {
    final data = await service.getAllSuppliers();
    setState(() {
      suppliers = data;
    });
  }

  void goToAddSupplier() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddSupplierScreen()),
    );

    if (result == true) loadSuppliers();
  }

  void editSupplier(Supplier supplier) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddSupplierScreen(supplier: supplier)),
    );

    if (result == true) loadSuppliers();
  }

  void deleteSupplier(int id) async {
    await service.deleteSupplier(id);
    loadSuppliers();
  }

  void confirmDelete(Supplier s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Supplier"),
        content: Text("Are you sure you want to delete ${s.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteSupplier(s.id!);
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
      backgroundColor: Color(0xFFBCF5FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Suppliers",
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
            child: suppliers.isEmpty
                ? Center(child: Text("No suppliers yet"))
                : ListView.builder(
                    itemCount: suppliers.length,
                    itemBuilder: (context, index) {
                      final s = suppliers[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.all(3),
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
                            // 👤 AVATAR
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.store,
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
                                  Text(
                                    s.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1A3C5A),
                                    ),
                                  ),

                                  SizedBox(height: 6),

                                  Row(
                                    children: [
                                      Icon(Icons.business, size: 16),
                                      SizedBox(width: 6),
                                      Text(s.company),
                                    ],
                                  ),

                                  SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 16),
                                      SizedBox(width: 6),
                                      Text(s.phone),
                                    ],
                                  ),

                                  SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16),
                                      SizedBox(width: 6),
                                      Text(s.address),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // ✏️ ACTIONS
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black54),
                                  onPressed: () => editSupplier(s),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () => confirmDelete(s),
                                ),
                              ],
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
              onTap: goToAddSupplier,
              text: "Add New Supplier",
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
