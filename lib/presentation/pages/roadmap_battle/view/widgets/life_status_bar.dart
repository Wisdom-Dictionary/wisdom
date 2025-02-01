import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';

class LifeStatusBar extends StatelessWidget {
  const LifeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.icons.heart),
        SvgPicture.asset(Assets.icons.heart),
        SvgPicture.asset(
          Assets.icons.heartSlash,
          colorFilter: ColorFilter.mode(AppColors.white.withValues(alpha: 0.5), BlendMode.srcIn),
        ),
      ],
    );
  }
}
