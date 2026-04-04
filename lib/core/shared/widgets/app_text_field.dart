import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20.w),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
