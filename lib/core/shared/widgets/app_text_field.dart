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
    this.maxLines,
    this.minLines,
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
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines != null && maxLines! > 1;
    return TextFormField(
      controller: controller,
      obscureText: isMultiline ? false : obscureText,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: isMultiline ? maxLines : 1,
      minLines: isMultiline ? minLines : null,
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
