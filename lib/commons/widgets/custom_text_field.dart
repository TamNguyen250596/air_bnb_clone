import 'package:flutter/material.dart';

// ========== Custom Text Field Widget ==========
class CustomTextField extends StatefulWidget {
  // ========== Properties ==========
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final int maxLines;

  // ========== Constructor ==========
  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
    this.maxLines = 1,
  });

  // ========== Lifecycle ==========
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

// ========== Custom Text Field State ==========
class _CustomTextFieldState extends State<CustomTextField> {
  // ========== Properties ==========
  bool _obscure = true;

  // ========== Lifecycle ==========
  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  // ========== Build Method ==========
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscure : false,
        maxLines: widget.maxLines,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon, color: Colors.white),
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.black,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
