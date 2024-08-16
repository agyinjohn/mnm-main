import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final bool isPassword;
  final IconData prefixIcon;
  final String hintText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.isPassword,
    required this.prefixIcon,
    required this.hintText,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _obscureText : false,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[300],
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) {
          if (val == null || val.isEmpty) {
            return 'Enter your ${widget.hintText}';
          }
          return null;
        },
      ),
    );
  }
}
