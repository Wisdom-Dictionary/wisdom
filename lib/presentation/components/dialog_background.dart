import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/constants.dart';

class DialogBackground extends StatelessWidget {
  const DialogBackground({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          child: child,
        ));
    ;
  }
}
