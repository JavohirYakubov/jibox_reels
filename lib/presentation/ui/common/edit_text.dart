import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/colors.gen.dart';

class EditText extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final String comment;
  final bool required;
  final bool enabled;
  final TextInputType? inputType;
  final Function(String v)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? minLines;
  final int? maxLines;

  EditText(this.title,
      {super.key,
      required this.textEditingController,
      this.required = false,
      this.onChanged,
      this.comment = "",
      this.inputType,
      this.inputFormatters,
      this.enabled = true,
      this.minLines, this.maxLines});

  @override
  State<EditText> createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  FocusNode focusNode = FocusNode();
  Timer? bouncedTimer;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: ColorName.gray50,
                border: widget.required && errorMessage.isNotEmpty
                    ? Border.all(color: ColorName.alertError200, width: 1.w)
                    : focusNode.hasFocus
                        ? Border.all(
                            color: ColorName.mainPrimary300, width: 1.w)
                        : null,
                borderRadius: BorderRadius.circular(12.w)),
            child: Row(
              children: [
                Expanded(
                    child: SizedBox(
                  child: TextField(
                    enabled: widget.enabled,
                    decoration: InputDecoration(
                      label: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: widget.title,
                              style: TextStyle(
                                  color: ColorName.textTertiaryLight,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp)),
                          if (widget.required)
                            TextSpan(
                                text: "*",
                                style: TextStyle(
                                    color: ColorName.alertError500Base,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp)),
                        ]),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: widget.required && errorMessage.isNotEmpty
                              ? ColorName.alertError500Base
                              : ColorName.textTertiaryLight),
                    ),
                    inputFormatters: widget.inputFormatters,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: ColorName.textPrimary,
                    ),
                    focusNode: focusNode,
                    controller: widget.textEditingController,
                    keyboardType: widget.inputType,
                    minLines: widget.minLines,
                    maxLines: widget.maxLines,
                    onChanged: (v) {
                      onChanged(v);
                    },
                  ),
                )),
              ],
            ),
          ),
          if (errorMessage.isNotEmpty)
            Container(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 4.h),
              child: Text(
                errorMessage,
                style: TextStyle(
                    color: ColorName.alertError500Base,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
          if (widget.comment.isNotEmpty)
            Container(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                widget.comment,
                style: TextStyle(
                    color: ColorName.textTertiaryLight,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400),
              ),
            ),
        ],
      ),
    );
  }

  void onChanged(String v) {
    if (widget.onChanged != null) {
      widget.onChanged!(v);
    }
    errorMessage = "";
    bouncedTimer?.cancel();
    bouncedTimer = Timer(Duration(seconds: 1), () {
      if (widget.required && v.isEmpty) {
        errorMessage = "Поле, обязательное для заполнения!";
        setState(() {});
      }
    });
    setState(() {});
  }
}
