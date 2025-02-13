import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/constants.dart';
import '../../../widgets/social_button.dart';

class UserActionButtons extends StatelessWidget {
  final Function save;
  final Function cancel;
  final bool isActive;

  const UserActionButtons({
    required this.save,
    required this.cancel,
    this.isActive = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.w),
      duration: Duration(milliseconds: isActive ? 300 : 0),
      height: isActive ? 50 : 0,
      child: Row(
        children: [
          Expanded(
            child: AppButtonWidget(
              onTap: () {
                cancel.call();
              },
              title: LocaleKeys.cancel.tr(),
              color: isDarkTheme ? AppColors.darkForm : AppColors.lightGray,
              height: 30,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: AppButtonWidget(
              onTap: () {
                save.call();
              },
              title: LocaleKeys.save.tr(),
              color: AppColors.blue,
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}