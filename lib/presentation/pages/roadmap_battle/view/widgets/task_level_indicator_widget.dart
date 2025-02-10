import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';

class FlagIndicatorWidget extends StatelessWidget {
  const FlagIndicatorWidget({super.key, required this.userLevel});
  final int userLevel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 9, left: 20, right: 18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue,
        border: Border.all(color: AppColors.borderWhite, width: 2),
      ),
      child: Column(
        children: [
          SvgPicture.asset(Assets.icons.flag),
          const SizedBox(
            height: 4,
          ),
          Text(
            "$userLevel",
            style: AppTextStyle.font15W500Normal.copyWith(fontSize: 14, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class InactiveLevelIndicator extends StatelessWidget {
  const InactiveLevelIndicator({super.key, required this.item, required this.activeLevel});

  final LevelModel item;
  final bool activeLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskLevelStarsIndicator(
          star: item.star ?? 0,
        ),
        const SizedBox(
          height: 4,
        ),
        activeLevel ? activeItemContent() : inactiveItemContent(),
      ],
    );
  }

  Widget activeItemContent() => Column(
        children: [
          SvgPicture.asset(Assets.icons.userAvatar),
          Transform.translate(
            offset: const Offset(0, -15),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              decoration: BoxDecoration(
                  color: AppColors.blue,
                  border: Border.all(color: AppColors.borderWhite, width: 2),
                  borderRadius: BorderRadius.circular(1000)),
              child: Text(
                item.name!,
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.white),
              ),
            ),
          )
        ],
      );

  Container inactiveItemContent() {
    final userLevel = item.userCurrentLevel ?? false;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.5.w, vertical: 4.h),
      decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(
                color: Color(0x33163757), offset: Offset(0, 8), blurRadius: 20, spreadRadius: 0)
          ],
          color: userLevel ? AppColors.bgAccent : AppColors.bgGray,
          border: Border.all(color: AppColors.lightBackground, width: 2),
          borderRadius: BorderRadius.circular(64)),
      child: Column(
        children: [
          Text(
            item.name!,
            style: AppTextStyle.font13W500Normal.copyWith(
                fontSize: 14, color: userLevel ? AppColors.white : AppColors.textDisabled),
          ),
          const SizedBox(
            height: 4,
          ),
          userLevel
              ? SvgPicture.asset(
                  Assets.icons.verify,
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                )
              : SvgPicture.asset(Assets.icons.lock),
        ],
      ),
    );
  }
}

class TaskLevelStarsIndicator extends StatelessWidget {
  const TaskLevelStarsIndicator({super.key, required this.star});
  final int star;

  String iconPath(int position) {
    if (position >= star) {
      return Assets.icons.starInactive;
    }
    return Assets.icons.starActive;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.translate(offset: const Offset(1, 4), child: SvgPicture.asset(iconPath(1))),
        SvgPicture.asset(iconPath(2)),
        Transform.translate(offset: const Offset(-1, 4), child: SvgPicture.asset(iconPath(3))),
      ],
    );
  }
}
