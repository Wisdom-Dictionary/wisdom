import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_decoration.dart';

class CustomOvalButtonExercise extends StatelessWidget {
  const CustomOvalButtonExercise({
    super.key,
    required this.label,
    required this.onTap,
    required this.textStyle,
    this.isActive = true,
    this.height,
    this.prefixIcon = false,
    this.imgAssets = '',
    this.containerColor,
  });

  final TextStyle textStyle;
  final String label;
  final Function() onTap;
  final bool isActive;
  final double? height;
  final bool prefixIcon;
  final String imgAssets;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isActive
          ? AppDecoration.activeButtonDecor.copyWith(color: containerColor)
          : AppDecoration.inactiveButtonDecor.copyWith(color: containerColor),
      height: height ?? 45.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(40.r),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                prefixIcon
                    ? SvgPicture.asset(imgAssets,
                        fit: BoxFit.scaleDown, color: isActive ? Colors.green : Colors.red)
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
