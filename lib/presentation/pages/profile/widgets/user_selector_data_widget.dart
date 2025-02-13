import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_text_style.dart';
import '../../../../config/constants/constants.dart';

class UserSelectorDataWidget extends StatelessWidget {
  final String title;
  final String? data;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool readOnly;
  final TextStyle? titleTextStyle;
  final TextStyle? dataTextStyle;
  final bool isVisible;
  final Function? onTap;

  const UserSelectorDataWidget({
    super.key,
    required this.title,
    this.data,
    required this.onChanged,
    this.hintText = '',
    this.readOnly = false,
    this.titleTextStyle,
    this.dataTextStyle,
    this.isVisible = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        height: 40.dg,
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: (isDarkTheme
                  ? AppColors.darkBackground
                  : AppColors.lightBackground)
              .withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: titleTextStyle ??
                  AppTextStyle.font12W400Normal.copyWith(
                    color: isDarkTheme ? AppColors.white : AppColors.blue,
                    fontSize: 12.sp,
                  ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                onTap: () {
                  onTap?.call();
                },
                controller: TextEditingController(text: data),
                readOnly: readOnly,
                onChanged: onChanged,
                textAlign: TextAlign.end,
                style: dataTextStyle ??
                    AppTextStyle.font12W600Normal.copyWith(
                      color: AppColors.blue,
                      fontSize: 12.sp,
                    ),
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: AppTextStyle.font12W400Normal.copyWith(
                    color: AppColors.lightGray,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
