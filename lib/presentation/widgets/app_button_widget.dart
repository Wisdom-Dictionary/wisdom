import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/extensions/app_extension.dart';

class SocialButtonWidget extends StatelessWidget {
  final Function onTap;
  final String title;
  final Widget? leftIcon;
  final TextStyle? textStyle;
  final Color? color;
  final EdgeInsetsGeometry margin;

  const SocialButtonWidget({
    required this.onTap,
    required this.title,
    this.textStyle,
    this.leftIcon,
    this.color = AppColors.blue,
    this.margin = EdgeInsets.zero,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: color,
      ),
      height: 45.dg,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap.call(),
          borderRadius: BorderRadius.circular(40.r),
          child: Center(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      leftIcon ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Text(
                        title.tr(),
                        style: textStyle ?? AppTextStyle.font15W500Normal,
                        textAlign: TextAlign.start,
                      ).paddingOnly(left: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
