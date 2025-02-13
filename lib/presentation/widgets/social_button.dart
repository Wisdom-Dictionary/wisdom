import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';

class AppButtonWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final Widget? leftIcon;
  final TextStyle? textStyle;
  final Color? color;
  final EdgeInsetsGeometry margin;
  final double height;

  const AppButtonWidget({
    required this.onTap,
    required this.title,
    this.textStyle,
    this.leftIcon,
    this.color = AppColors.blue,
    this.margin = EdgeInsets.zero,
    this.height = 45.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: color,
      ),
      height: height.dg,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap.call(),
          borderRadius: BorderRadius.circular(40.r),
          child: Center(
            child: Text(
              title.tr(),
              style: textStyle ?? AppTextStyle.font15W500Normal.copyWith(fontSize: 15.sp),
              textAlign: TextAlign.start,
            ),
          ),
        ),
      ),
    );
  }
}
