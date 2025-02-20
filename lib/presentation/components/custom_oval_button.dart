import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';

class CustomOvalButton extends StatelessWidget {
  const CustomOvalButton(
      {super.key,
      required this.label,
      required this.onTap,
      required this.textStyle,
      this.isActive = true,
      this.height,
      this.prefixIcon = false,
      this.imgAssets = '',
      this.containerColor,
      this.padding});

  // : assert(!prefixIcon && imgAssets != '', "imgAssets can not be empty while prefixIcon is true");

  final TextStyle textStyle;
  final String label;
  final Function() onTap;
  final bool isActive;
  final double? height;
  final bool prefixIcon;
  final String imgAssets;
  final Color? containerColor;
  final EdgeInsets? padding;

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  prefixIcon
                      ? Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: SvgPicture.asset(imgAssets,
                              height: 16.h,
                              fit: BoxFit.scaleDown,
                              color: isActive ? AppColors.white : AppColors.black),
                        )
                      : const SizedBox.shrink(),
                  Flexible(
                    child: Text(
                      label,
                      style:
                          textStyle.copyWith(color: isActive ? AppColors.white : AppColors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
