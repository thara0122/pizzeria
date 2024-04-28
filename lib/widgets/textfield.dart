import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hint,
      required this.label,
      this.controller,
      this.enabled = true,
      this.isPassword = false});
  final String hint;
  final String label;
  final bool isPassword;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: enabled,
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          label: Text(label),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.grey, width: 1))),
    );
  }
}
