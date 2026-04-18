import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;

  AddEmployeeScreen({this.employee});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final dob = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final nid = TextEditingController();
  final role = TextEditingController();
  final address = TextEditingController();

  final service = EmployeeService();

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      name.text = widget.employee!.name;
      dob.text = widget.employee!.dob;
      phone.text = widget.employee!.phone;
      email.text = widget.employee!.email;
      nid.text = widget.employee!.nid;
      role.text = widget.employee!.role;
      address.text = widget.employee!.address;
    }
  }

  // 📅 DATE PICKER
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dob.text = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  void saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.employee == null) {
      await service.insertEmployee(
        Employee(
          name: name.text,
          dob: dob.text,
          phone: phone.text,
          email: email.text,
          nid: nid.text,
          role: role.text,
          address: address.text,
        ),
      );
    } else {
      await service.updateEmployee(
        Employee(
          id: widget.employee!.id,
          name: name.text,
          dob: dob.text,
          phone: phone.text,
          email: email.text,
          nid: nid.text,
          role: role.text,
          address: address.text,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Employee saved successfully"),
        backgroundColor: Color(0xFF4A90E2),
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
          widget.employee == null ? "Add Employee" : "Update Employee",
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
                  // 👥 HEADER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFE3F2FD),
                        child: Icon(
                          Icons.people,
                          color: Color(0xFF4A90E2),
                          size: 28,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        widget.employee == null
                            ? "New Employee"
                            : "Edit Employee",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3C5A),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  buildField(name, "Employee Name", Icons.person),
                  SizedBox(height: 12),

                  // 📅 DOB
                  TextFormField(
                    controller: dob,
                    readOnly: true,
                    onTap: pickDate,
                    validator: (value) =>
                        value!.isEmpty ? "Select date of birth" : null,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4A90E2),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  SizedBox(height: 12),

                  buildField(phone, "Phone", Icons.phone),
                  SizedBox(height: 12),

                  buildField(email, "Email", Icons.email),
                  SizedBox(height: 12),

                  buildField(nid, "NID", Icons.credit_card),
                  SizedBox(height: 12),

                  buildField(role, "Role", Icons.work),
                  SizedBox(height: 12),

                  buildField(address, "Address", Icons.location_on),

                  SizedBox(height: 25),

                  // 🔥 ANIMATED BUTTON
                  AnimatedButton(
                    onTap: saveEmployee,
                    text: widget.employee == null
                        ? "Add Employee"
                        : "Update Employee",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
