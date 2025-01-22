import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/pages/home/viewmodel/home_viewmodel.dart';
import 'package:badges/badges.dart' as badges;

import '../../config/constants/assets.dart';
import '../components/navigation_button.dart';

class HomeBottomNavBar extends ViewModelWidget<HomeViewModel> {
  const HomeBottomNavBar({Key? key, required this.onTap}) : super(key: key);

  final Function(int index) onTap;

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return ValueListenableBuilder(
      valueListenable: viewModel.localViewModel.currentIndex,
      builder: (context, value, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
              color: (isDarkTheme ? AppColors.darkBottomBar : AppColors.blue).withOpacity(0.95),
            ),
            padding: EdgeInsets.only(top: 8.h),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeyHome,
                      title: 'Home',
                      description: "Bosh sahifa",
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
                        color: (isDarkTheme ? AppColors.darkBottomBar : AppColors.blue).withOpacity(0.1),
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
                                      style: AppTextStyle.font13W500Normal.copyWith(fontSize: 12.sp),
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
                                        description: "Saqlangan so'zlarni ko'rish va ular ustida mashq qilish",
                                        titleAlignment: TextAlign.center,
                                        titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                                        descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
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
                      description: "So'z va iboralar qidiruvi",
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
                      key: viewModel.globalKeyCategory,
                      title: 'Catalogue',
                      description: "So'zlarga oid grammatik va amaliy foydalanish qounun qoidalari ro'yhati",
                      titleAlignment: TextAlign.center,
                      titleTextStyle: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue),
                      descTextStyle: AppTextStyle.font15W500Normal.copyWith(color: AppColors.blue),
                      disableDefaultTargetGestures: false,
                      showArrow: true,
                      child: BottomNavButton(
                          isTabSelected: value == 3,
                          defIcon: Assets.icons.unitsOutline,
                          filledIcon: Assets.icons.unitsFilled,
                          callBack: () {
                            onTap(3);
                            viewModel.localViewModel.isFinal = false;
                            viewModel.localViewModel.isTitle = false;
                            viewModel.localViewModel.isSubSub = false;
                            viewModel.localViewModel.subId = -1;
                            viewModel.localViewModel.changePageIndex(3);
                          }),
                    ),
                  ),
                  Expanded(
                    child: Showcase(
                      key: viewModel.globalKeyTranslation,
                      description: 'Gap va tekslarni tarjima qilish',
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
