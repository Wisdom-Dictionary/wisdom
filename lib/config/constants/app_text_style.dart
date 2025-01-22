import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

abstract class AppTextStyle {
  const AppTextStyle._();

  static const String fontFamily = "Montserrat";

  static TextStyle font15W500Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 15.sp,
    color: AppColors.white,
  );

  static TextStyle font15W600Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 15.sp,
    color: AppColors.white,
  );

  static TextStyle font15W700Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 15.sp,
    color: AppColors.white,
  );

  static TextStyle font17W400Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 17.sp,
    color: AppColors.white,
  );

  static TextStyle font17W500Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 17.sp,
    color: AppColors.white,
  );

  static TextStyle font17W700Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 17.sp,
    color: AppColors.white,
  );

  static TextStyle font17W600Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 17.sp,
    color: AppColors.white,
  );

  static TextStyle font17W500Italic = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.italic,
    fontSize: 17.sp,
    color: AppColors.white,
  );

  static TextStyle font15W400Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 15.sp,
    color: AppColors.white,
  );

  static TextStyle font13W400Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 13.sp,
    color: AppColors.white,
  );

  static TextStyle font13W500Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 13.sp,
    color: AppColors.white,
  );

  static TextStyle font28W600Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 28.sp,
    color: AppColors.white,
  );

  static TextStyle font19W500Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 19.sp,
    color: AppColors.white,
  );

  static TextStyle font18W400Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 18.sp,
    color: AppColors.white,
  );

  static TextStyle font18W500Normal = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontSize: 18.sp,
    color: AppColors.white,
  );

  // =========================== For Html texts ===================//

  static TextStyle font15W400ItalicHtml = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: 15.sp,
    color: AppColors.darkGray,
  );

  static TextStyle font15W400NormalHtml = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 15.sp,
    color: AppColors.darkGray,
  );

  static TextStyle font13W400ItalicHtml = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: 13.sp,
    color: AppColors.darkGray,
  );
}
