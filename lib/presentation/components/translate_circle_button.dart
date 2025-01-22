import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/constants/app_colors.dart';

class TranslateCircleButton extends StatelessWidget {
  const TranslateCircleButton({super.key, required this.onTap, required this.iconAssets});

  final Function() onTap;
  final String iconAssets;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(23.r),
        onTap: () => onTap(),
        child: Container(
          height: 46.h,
          width: 46.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(23.r),
            color: AppColors.blue.withOpacity(0.1),
          ),
          child: SvgPicture.asset(
            iconAssets,
            height: 19.h,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }
}
