import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'add_employee_screen.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final EmployeeService service = EmployeeService();

  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];

  String? selectedRole;

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  void loadEmployees() async {
    final data = await service.getAllEmployees();

    setState(() {
      employees = data;

      if (selectedRole == null || selectedRole == "All") {
        filteredEmployees = employees;
      } else {
        if (!employees.any((e) => e.role == selectedRole)) {
          selectedRole = null;
          filteredEmployees = employees;
        } else {
          filteredEmployees = employees
              .where((e) => e.role == selectedRole)
              .toList();
        }
      }
    });
  }

  void filterByRole(String? role) {
    setState(() {
      selectedRole = role;

      if (role == null || role == "All") {
        filteredEmployees = employees;
      } else {
        filteredEmployees = employees.where((e) => e.role == role).toList();
      }
    });
  }

  void goToAddEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEmployeeScreen()),
    );

    if (result == true) loadEmployees();
  }

  void editEmployee(Employee e) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEmployeeScreen(employee: e)),
    );

    if (result == true) loadEmployees();
  }

  void deleteEmployee(int id) async {
    await service.deleteEmployee(id);
    selectedRole = null;
    loadEmployees();
  }

  void confirmDelete(Employee e) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete ${e.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEmployee(e.id!);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> roles = employees.map((e) => e.role).toSet().toList();

    return Scaffold(
      backgroundColor: Color(0xFFBCF5FF),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Employees",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF1A3C5A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          // 🔽 FILTER
          Padding(
            padding: EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value:
                  (selectedRole != null &&
                      ["All", ...roles].contains(selectedRole))
                  ? selectedRole
                  : null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint: Text("Filter by Role"),
              items: ["All", ...roles].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: filterByRole,
            ),
          ),

          // 📋 LIST
          Expanded(
            child: filteredEmployees.isEmpty
                ? Center(child: Text("No employees found"))
                : ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final e = filteredEmployees[index];

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Color(0xFF4A90E2),
                              ),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1A3C5A),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 16),
                                      SizedBox(width: 6),
                                      Text(e.phone),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.work, size: 16),
                                      SizedBox(width: 6),
                                      Text(e.role),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black54),
                                  onPressed: () => editEmployee(e),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  ),
                                  onPressed: () => confirmDelete(e),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: EdgeInsets.all(12),
            child: AnimatedButton(
              onTap: goToAddEmployee,
              text: "Add New Employee",
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
      opacity = 0.8;
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
