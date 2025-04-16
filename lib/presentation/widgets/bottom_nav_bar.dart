import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/presentation/components/dialog_background.dart';
import 'package:wisdom/presentation/pages/home/viewmodel/home_viewmodel.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/sign_in_dialog.dart';

import '../../config/constants/assets.dart';
import '../components/navigation_button.dart';

class HomeBottomNavBar extends ViewModelWidget<HomeViewModel> {
  const HomeBottomNavBar({super.key, required this.onTap});

  final Function(int index) onTap;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final bool isLoggedIn =
        locator.get<SharedPreferenceHelper>().getString(Constants.KEY_TOKEN, '') != '';
    return ValueListenableBuilder(
      valueListenable: viewModel.localViewModel.currentIndex,
      builder: (context, value, child) {
        return Positioned(
          bottom: 6,
          left: 6,
          right: 6,
          child: SafeArea(
            top: false,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(256.r),
                color: (isDarkTheme ? AppColors.darkBottomBar : AppColors.blue).withOpacity(0.95),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeyHome,
                      title: 'Home',
                      description: LocaleKeys.main_page.tr(),
                      titleAlignment: TextAlign.end,
                      titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                      descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                      disableDefaultTargetGestures: true,
                      showArrow: true,
                      child: BottomNavButton(
                          isTabSelected: value == 0,
                          defIcon: Assets.icons.homeOutline,
                          filledIcon: Assets.icons.homeFilled,
                          callBack: () {
                            onTap(0);
                            viewModel.localViewModel.changePageIndex(0);
                          }),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onTap(1);
                      },
                      child: Material(
                        color: (isDarkTheme ? AppColors.darkBottomBar : AppColors.blue)
                            .withOpacity(0.1),
                        child: ValueListenableBuilder(
                          valueListenable: viewModel.localViewModel.badgeCount,
                          builder: (BuildContext context, int valueBadge, Widget? child) {
                            return Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  badges.Badge(
                                    position: badges.BadgePosition.topEnd(top: -5),
                                    badgeContent: Text(
                                      valueBadge.toString(),
                                      style:
                                          AppTextStyle.font13W500Normal.copyWith(fontSize: 12.sp),
                                    ),
                                    badgeStyle: badges.BadgeStyle(
                                      shape: badges.BadgeShape.circle,
                                      badgeColor: Colors.red,
                                      padding: const EdgeInsets.all(5),
                                      borderRadius: BorderRadius.circular(4),
                                      elevation: 0,
                                    ),
                                    child: AddToCartIcon(
                                      badgeOptions: const BadgeOptions(
                                          active: false,
                                          fontSize: 12,
                                          width: 40,
                                          backgroundColor: AppColors.accentLight,
                                          foregroundColor: AppColors.white),
                                      key: viewModel.localViewModel.cartKey,
                                      icon: Showcase(
                                        key: viewModel.globalKeyWordBank,
                                        title: 'NoteBook',
                                        description: LocaleKeys.saved_words.tr(),
                                        titleAlignment: TextAlign.center,
                                        titleTextStyle: AppTextStyle.font17W600Normal
                                            .copyWith(color: AppColors.blue),
                                        descTextStyle: AppTextStyle.font15W500Normal
                                            .copyWith(color: AppColors.blue),
                                        disableDefaultTargetGestures: true,
                                        showArrow: true,
                                        child: BottomNavButton(
                                            isTabSelected: value == 1,
                                            defIcon: Assets.icons.bookOutline,
                                            filledIcon: Assets.icons.bookFilled,
                                            callBack: () {
                                              onTap(1);
                                              viewModel.localViewModel.changePageIndex(23);
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeySearch,
                      title: 'Search',
                      description: LocaleKeys.search_words.tr(),
                      titleAlignment: TextAlign.center,
                      titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                      descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                      disableDefaultTargetGestures: false,
                      showArrow: true,
                      child: BottomNavButton(
                          isTabSelected: value == 2,
                          defIcon: Assets.icons.searchOutline,
                          filledIcon: Assets.icons.searchFilled,
                          callBack: () {
                            // onTap(2);
                            viewModel.localViewModel.changePageIndex(2);
                          }),
                    ),
                  ),
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeyRoadmapBattle,
                      title: 'Roadmap Battle',
                      description: "Battle",
                      titleAlignment: TextAlign.center,
                      titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                      descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                      disableDefaultTargetGestures: false,
                      showArrow: true,
                      child: BottomNavButton(
                          isTabSelected: value == 3,
                          defIcon: Assets.icons.cupOutlined,
                          filledIcon: Assets.icons.cup,
                          callBack: () {
                            viewModel.sharedPref.putInt(Constants.KEY_LATEST_SELECTED_INDEX, 3);

                            if (!isLoggedIn) {
                              showDialog(
                                context: context,
                                builder: (context) => const DialogBackground(
                                  child: SignInDialog(),
                                ),
                              );
                              return;
                            }
                            onTap(3);
                            viewModel.localViewModel.changePageIndex(3);

                            viewModel.localViewModel.isFinal = false;
                            viewModel.localViewModel.isTitle = false;
                            viewModel.localViewModel.isSubSub = false;
                            viewModel.localViewModel.subId = -1;
                          }),
                    ),
                  ),
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeyTranslation,
                      description: LocaleKeys.translate.tr(),
                      title: 'Translate',
                      titleAlignment: TextAlign.center,
                      titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                      descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                      disableDefaultTargetGestures: false,
                      showArrow: true,
                      onTargetClick: () {
                        viewModel.isShow.value = true;
                      },
                      disposeOnTap: false,
                      child: BottomNavButton(
                          isTabSelected: value == 4,
                          defIcon: Assets.icons.translateOutline,
                          filledIcon: Assets.icons.translateFilled,
                          callBack: () {
                            onTap(4);
                            viewModel.localViewModel.changePageIndex(4);
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
