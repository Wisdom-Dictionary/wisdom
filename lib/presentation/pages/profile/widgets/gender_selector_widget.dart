import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/constants.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../data/enums/gender.dart';

class GenderSelectorDialog extends StatelessWidget {
  const GenderSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.white,
      title: Text(
        LocaleKeys.select_gender.tr(),
        style: const TextStyle(color: Colors.blue),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              Gender.M.localeName,
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context, Gender.M);
            },
          ),
          ListTile(
            title: Text(
              Gender.F.localeName,
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.pop(context, Gender.F);
            },
          ),
        ],
      ),
    );
  }
}