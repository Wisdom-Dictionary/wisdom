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
  final EdgeInsets? padding;
  final double? borderRadius;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? child;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? titleColor;
  final Function() onTap;
  final bool isDisable;
  final bool isLoading;

  const WButton({
    Key? key,
    this.color,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.title,
    this.titleStyle,
    this.child,
    this.splashColor,
    this.highlightColor,
    this.focusColor,
    this.hoverColor,
    this.titleColor,
    this.isLoading = false,
    required this.onTap,
    this.isDisable = false,
  }) : super(key: key);

  Widget get progressIndicator => SizedBox(
        height: 17,
        width: 17,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: titleColor ?? titleStyle?.color ?? AppColors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
          color: isDisable ? AppColors.gray80 : color ?? AppColors.blue),
      height: height ?? 45.h,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            highlightColor: highlightColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            splashColor: splashColor,
            onTap: isDisable || isLoading ? null : () => onTap(),
            borderRadius: BorderRadius.circular(borderRadius ?? 40.r),
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 8),
              child: title != null
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              title ?? "",
                              style: titleStyle ??
                                  AppTextStyle.font15W500Normal.copyWith(color: titleColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLoading) ...[
                            const SizedBox(
                              width: 6,
                            ),
                            progressIndicator
                          ]
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(child: child ?? const Center()),
                        if (isLoading) ...[
                          const SizedBox(
                            width: 6,
                          ),
                          progressIndicator
                        ]
                      ],
                    ),
            )),
      ),
    );
  }
}
