import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';

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

class BattleItem extends StatelessWidget {
  const BattleItem({super.key, required this.item});

  final LevelModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LevelStarsIndicator(
          star: item.star ?? 0,
        ),
        Stack(
          children: [
            SvgPicture.asset(Assets.icons.battleItem),
            Positioned.fill(
                top: 7,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Battle",
                        style: AppTextStyle.font13W500Normal
                            .copyWith(fontSize: 10, color: AppColors.blue),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      item.starsToUnlock == null
                          ? SvgPicture.asset(
                              Assets.icons.lock,
                              colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                            )
                          : starsToUnlock(item.starsToUnlock!)
                    ],
                  ),
                ))
          ],
        ),
      ],
    );
  }

  Column starsToUnlock(int starsToUnlock) {
    return Column(
      children: [
        Container(
          width: 12.5,
          height: 8,
          decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 2,
                  color: AppColors.blue,
                  style: BorderStyle.solid,
                ),
                right: BorderSide(
                  width: 2,
                  color: AppColors.blue,
                  style: BorderStyle.solid,
                ),
                top: BorderSide(
                  width: 2,
                  color: AppColors.blue,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3))),
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2.71, vertical: 2.5),
            decoration:
                BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(3)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  " $starsToUnlock ",
                  style:
                      AppTextStyle.font13W500Normal.copyWith(color: AppColors.white, fontSize: 6),
                ),
                SvgPicture.asset(
                  height: 6,
                  width: 6,
                  Assets.icons.starFull,
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ActiveLevelItem extends StatelessWidget {
  const ActiveLevelItem({super.key, required this.item});
  final LevelModel item;
  @override
  Widget build(BuildContext context) {
    return Column(
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
            child: locator<RoadmapRepository>().userRank == null
                ? Text(
                    item.name ?? "",
                    style:
                        AppTextStyle.font13W500Normal.copyWith(fontSize: 8, color: AppColors.white),
                  )
                : Row(
                    children: [
                      Text(
                        locator<RoadmapRepository>().userRank?.name ?? "",
                        style: AppTextStyle.font13W500Normal
                            .copyWith(fontSize: 8, color: AppColors.white),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Image.network(
                        height: 16,
                        width: 16,
                        locator<RoadmapRepository>().userRank?.icon ?? "",
                        errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                          Assets.icons.wifiOff,
                          height: 16,
                          width: 16,
                          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                        ),
                      )
                    ],
                  ),
          ),
        )
      ],
    );
  }
}

class LevelItem extends StatelessWidget {
  const LevelItem({super.key, required this.item});
  final LevelModel item;

  @override
  Widget build(BuildContext context) {
    final completedLevel = (item.star ?? 0) != 0;
    return Column(
      children: [
        LevelStarsIndicator(
          star: item.star ?? 0,
        ),
        (item.userCurrentLevel ?? false)
            ? ActiveLevelItem(
                item: item,
              )
            : InActiveLevelItem(completedLevel: completedLevel, item: item)
      ],
    );
  }
}

class InActiveLevelItem extends StatelessWidget {
  const InActiveLevelItem({
    super.key,
    required this.completedLevel,
    required this.item,
  });

  final bool completedLevel;
  final LevelModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.5.w, vertical: 4.h),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color(0x33163757), offset: Offset(0, 8), blurRadius: 20, spreadRadius: 0)
          ],
          color: completedLevel ? AppColors.bgAccent : AppColors.bgGray,
          border: Border.all(color: AppColors.lightBackground, width: 2),
          borderRadius: BorderRadius.circular(64)),
      child: Column(
        children: [
          Text(
            item.name!,
            style: AppTextStyle.font13W500Normal.copyWith(
                fontSize: 14, color: completedLevel ? AppColors.white : AppColors.textDisabled),
          ),
          const SizedBox(
            height: 4,
          ),
          completedLevel
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

class TestItem extends StatelessWidget {
  const TestItem({super.key, required this.item});
  final LevelModel item;
  @override
  Widget build(BuildContext context) {
    final completedLevel = (item.star ?? 0) != 0;
    return Column(
      children: [
        LevelStarsIndicator(
          star: item.star ?? 0,
          isTestItem: true,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.5.w, vertical: 4.h),
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33163757), offset: Offset(0, 8), blurRadius: 20, spreadRadius: 0)
              ],
              color:
                  Color.alphaBlend(AppColors.vibrantBlue.withValues(alpha: 0.15), AppColors.white),
              border: Border.all(color: AppColors.blue, width: 2),
              borderRadius: BorderRadius.circular(64)),
          child: Column(
            children: [
              Text(
                item.name!,
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
              ),
              const SizedBox(
                height: 4,
              ),
              completedLevel
                  ? SvgPicture.asset(
                      Assets.icons.verify,
                      colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                    )
                  : SvgPicture.asset(Assets.icons.lock,
                      colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn)),
            ],
          ),
        ),
      ],
    );
  }
}

class LevelStarsIndicator extends StatelessWidget {
  const LevelStarsIndicator({super.key, required this.star, this.isTestItem = false});
  final int star;
  final bool isTestItem;

  String iconPath(int position) {
    if (position > star) {
      if (isTestItem) {
        return Assets.icons.starInactiveTest;
      }
      return Assets.icons.starInactive;
    }
    return Assets.icons.starActive;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(offset: const Offset(1, 4), child: SvgPicture.asset(iconPath(1))),
            SvgPicture.asset(iconPath(2)),
            Transform.translate(offset: const Offset(-1, 4), child: SvgPicture.asset(iconPath(3))),
          ],
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}
