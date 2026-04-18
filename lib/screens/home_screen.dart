import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'product_screen.dart';
import 'employee_screen.dart';
import 'supplier_screen.dart';
import 'sales_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  // ✅ FIXED: Direct initialization (no late error)
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 SWIPE ENABLED BODY
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          DashboardScreen(),
          ProductScreen(),
          EmployeeScreen(),
          SupplierScreen(),
          SalesScreen(),
        ],
      ),

      // 🔵 NAV BAR (MATCHES YOUR THEME)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return buildNavItem(index);
          }),
        ),
      ),
    );
  }

  Widget buildNavItem(int index) {
    final icons = [
      Icons.dashboard,
      Icons.inventory,
      Icons.people,
      Icons.local_shipping,
      Icons.point_of_sale,
    ];

    final labels = ["Dashboard", "Products", "Employees", "Suppliers", "Sales"];

    bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });

        // 🔥 Sync tap with swipe
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: isSelected
              ? Color(0xFF4A90E2).withOpacity(0.15)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: Duration(milliseconds: 200),
              scale: isSelected ? 1.2 : 1.0,
              child: Icon(
                icons[index],
                color: isSelected ? Color(0xFF4A90E2) : Color(0xFF1A3C5A),
              ),
            ),
            SizedBox(height: 4),
            Text(
              labels[index],
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Color(0xFF4A90E2) : Color(0xFF1A3C5A),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
