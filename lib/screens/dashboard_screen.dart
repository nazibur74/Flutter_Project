import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../services/employee_service.dart';
import '../services/supplier_service.dart';
import '../services/sales_service.dart';
import '../services/export_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final productService = ProductService();
  final employeeService = EmployeeService();
  final supplierService = SupplierService();
  final salesService = SalesService();

  int products = 0;
  int employees = 0;
  int suppliers = 0;
  int sales = 0;

  double todaySales = 0;
  List<Map<String, dynamic>> recentSales = [];
  List<Map<String, dynamic>> lowStock = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  void loadData() async {
    final p = await productService.getProductCount();
    final e = await employeeService.getEmployeeCount();
    final s = await supplierService.getSupplierCount();
    final sa = await salesService.getSalesCount();

    double today = 0;
    List<Map<String, dynamic>> recent = [];
    List<Map<String, dynamic>> low = [];

    try {
      today = await salesService.getTodaySalesTotal();
      recent = await salesService.getRecentSales();
    } catch (_) {}

    try {
      low = await productService.getLowStockProducts();
    } catch (_) {}

    setState(() {
      products = p;
      employees = e;
      suppliers = s;
      sales = sa;
      todaySales = today;
      recentSales = recent;
      lowStock = low;
    });
  }

  // 📤 EXPORT FUNCTIONS

  void exportProducts() async {
    final data = await productService.getAllProducts();

    List<List<dynamic>> rows = data
        .map((p) => [p.id, p.name, p.description, p.price, p.quantity])
        .toList();

    String path = await ExportService.exportToExcel("products", [
      "ID",
      "Name",
      "Description",
      "Price",
      "Stock",
    ], rows);

    showMessage("Products exported\n$path");
  }

  void exportEmployees() async {
    final data = await employeeService.getAllEmployees();

    List<List<dynamic>> rows = data
        .map((e) => [e.id, e.name, e.phone, e.role, e.address])
        .toList();

    String path = await ExportService.exportToExcel("employees", [
      "ID",
      "Name",
      "Phone",
      "Role",
      "Address",
    ], rows);

    showMessage("Employees exported\n$path");
  }

  void exportSuppliers() async {
    final data = await supplierService.getAllSuppliers();

    List<List<dynamic>> rows = data
        .map((s) => [s.id, s.name, s.company, s.phone, s.address])
        .toList();

    String path = await ExportService.exportToExcel("suppliers", [
      "ID",
      "Name",
      "Company",
      "Phone",
      "Address",
    ], rows);

    showMessage("Suppliers exported\n$path");
  }

  void exportSales() async {
    final data = await salesService.getAllSales();

    List<List<dynamic>> rows = data
        .map(
          (s) => [
            s['id'],
            s['customer_name'],
            s['phone'],
            s['total_amount'],
            s['date'],
          ],
        )
        .toList();

    String path = await ExportService.exportToExcel("sales", [
      "ID",
      "Customer",
      "Phone",
      "Total",
      "Date",
    ], rows);

    showMessage("Sales exported\n$path");
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFBCF5FF),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Zstore",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3C5A),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  buildCard(
                    "Products",
                    products.toString(),
                    Icons.inventory,
                    exportProducts,
                  ),
                  buildCard(
                    "Employees",
                    employees.toString(),
                    Icons.people,
                    exportEmployees,
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  buildCard(
                    "Suppliers",
                    suppliers.toString(),
                    Icons.store,
                    exportSuppliers,
                  ),
                  buildCard(
                    "Sales",
                    sales.toString(),
                    Icons.bar_chart,
                    exportSales,
                  ),
                ],
              ),

              SizedBox(height: 20),

              buildBox("Today's Sales", "৳ ${todaySales.toStringAsFixed(2)}"),

              SizedBox(height: 20),

              buildListBox(
                "Recent Sales",
                recentSales,
                (sale) => ListTile(
                  title: Text(sale['customer_name'] ?? "Unknown"),
                  trailing: Text("৳ ${(sale['total_amount'] ?? 0)}"),
                ),
                emptyText: "No recent sales",
              ),

              SizedBox(height: 20),

              buildListBox(
                "Low Stock",
                lowStock,
                (p) => ListTile(
                  title: Text(p['name']),
                  trailing: Text("Qty: ${p['quantity']}"),
                ),
                emptyText: "All products are in stock",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔷 CARD (FIXED ALIGNMENT)
  Widget buildCard(
    String title,
    String value,
    IconData icon,
    VoidCallback onDownload,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(15),
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
        child: Stack(
          children: [
            // CENTER CONTENT
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Color(0xFF4A90E2)),
                  SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1A3C5A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ],
              ),
            ),

            // DOWNLOAD ICON
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showMessage("Exporting $title...");
                  onDownload();
                },
                child: Icon(Icons.download, size: 20, color: Color(0xFF4A90E2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔷 BOX (RESTORED DESIGN)
  Widget buildBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF1A3C5A),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
        ],
      ),
    );
  }

  // 🔷 LIST BOX
  Widget buildListBox(
    String title,
    List data,
    Widget Function(dynamic) builder, {
    required String emptyText,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3C5A),
            ),
          ),
          SizedBox(height: 10),
          if (data.isEmpty) Text(emptyText),
          ...data.map((e) => builder(e)).toList(),
        ],
      ),
    );
  }
}
