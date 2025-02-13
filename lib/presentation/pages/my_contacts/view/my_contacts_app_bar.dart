import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';

// ignore: must_be_immutable
class MyContactsAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyContactsAppBar({
    super.key,
    this.title,
    this.child,
    this.bottom,
    this.actions = const [],
  });

  final String? title;
  final Widget? child;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  @override
  State<MyContactsAppBar> createState() => _MyContactsAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(121.h);
}

class _MyContactsAppBarState extends State<MyContactsAppBar> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> hasText = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: (isDarkTheme ? AppColors.darkForm : AppColors.blue)
          .withValues(alpha: 0.95),
      shadowColor:
          isDarkTheme ? null : const Color(0xFF6D8DAD).withValues(alpha: 0.15),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      actions: widget.actions,
      leading: InkResponse(
        onTap: () => Navigator.pop(context),
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
        padding: EdgeInsets.only(top: 12.h),
        child: widget.title != null
            ? Text(widget.title!, style: AppTextStyle.font15W500Normal)
            : widget.child,
      ),
      bottom: widget.bottom,
    );
  }
}
