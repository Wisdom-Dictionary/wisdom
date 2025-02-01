// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';

class WButton extends StatelessWidget {
  final Color? color;
  final double? height;
  final EdgeInsets? margin;
  final double? borderRadius;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Function() onTap;
  final bool isDisable;

  const WButton({
    Key? key,
    this.color,
    this.height,
    this.margin,
    this.borderRadius,
    this.title,
    this.titleStyle,
    this.child,
    this.splashColor,
    this.highlightColor,
    this.focusColor,
    this.hoverColor,
    required this.onTap,
    this.isDisable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
          color: isDisable ? AppColors.gray80 : color ?? AppColors.blue),
      height: 45.h,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: highlightColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          splashColor: splashColor,
          onTap: isDisable ? null : () => onTap(),
          borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
          child: title != null
              ? Center(
                  child: Flexible(
                    child: Text(
                      title ?? 'start_the_exercise'.tr(),
                      style: titleStyle ?? AppTextStyle.font15W500Normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
              : child ?? const Center(),
        ),
      ),
    );
  }
}
