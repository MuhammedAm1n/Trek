import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_diary/Core/theming/Coloring.dart';

class AppTextFormField extends StatelessWidget {
  AppTextFormField(
      {super.key,
      required this.hintText,
      this.hintStyle,
      this.inputTextStyle,
      this.IsObscureText,
      this.suffixIcon,
      this.FoucusBorder,
      this.enabledBorder,
      this.edgeInsets,
      this.controller,
      this.validator,
      this.scrollPaddingz,
      this.decoration,
      this.onTap,
      this.onChanged,
      this.keyboardType});
  final TextInputType? keyboardType;
  final EdgeInsets? edgeInsets;
  final String hintText;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;
  final bool? IsObscureText;
  final Widget? suffixIcon;
  final InputBorder? FoucusBorder;
  final InputBorder? enabledBorder;
  final EdgeInsets? scrollPaddingz;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final Function(String)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      onTap: onTap,
      decoration: decoration ??
          InputDecoration(
            // padding of TextFormField
            contentPadding: edgeInsets ??
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            isDense: true,
            // hint text of TextFormFIeld
            hintText: hintText,

            // hint style of hintText
            hintStyle:
                hintStyle ?? TextStyle(fontSize: 14, color: Colors.white),
            // IIcon in TextFormFIeld
            suffixIcon: suffixIcon,

            //Border's of TextFormField
            enabledBorder: enabledBorder ??
                OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(16)),
            focusedBorder: FoucusBorder ??
                OutlineInputBorder(
                  borderSide: BorderSide(color: ColorsApp.mainOrange),
                  borderRadius: BorderRadius.circular(16),
                ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
      obscureText: IsObscureText ?? false,
      style: inputTextStyle ?? const TextStyle(color: Colors.white),
      validator: (value) {
        return validator!(value!);
      },
      controller: controller,
      scrollPadding: scrollPaddingz ?? EdgeInsets.only(bottom: 30),
    );
  }
}
