import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';

import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final Widget bottomWidget;

  const ProfileAppBar({
    required this.actions,
    required this.bottomWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: (isDarkTheme ? AppColors.darkForm : AppColors.blue).withOpacity(0.95),
      shadowColor: isDarkTheme ? null : const Color(0xFF6D8DAD).withOpacity(0.15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      actions: actions,
      leading: InkResponse(
        onTap: ()  {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 5.w,
            right: 5.w,
            top: 15.h,
          ),
          child: SvgPicture.asset(
            Assets.icons.arrowLeft,
            height: 24.h,
            width: 24.h,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.only(top: 15.h),
        child: Text(
          "personal_cabinet".tr(),
          style: AppTextStyle.font15W500Normal,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: bottomWidget,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(160.h);
}
