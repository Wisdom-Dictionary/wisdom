import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/extensions/string_extension.dart';
import 'package:wisdom/presentation/components/shimmer.dart';
import 'package:wisdom/presentation/pages/profile/viewmodel/profile_page_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class UserCabinetPage extends ViewModelBuilderWidget<ProfilePageViewModel> {
  UserCabinetPage({super.key});

  @override
  void onViewModelReady(ProfilePageViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getUserDetails();
  }

  @override
  Widget builder(
    BuildContext context,
    ProfilePageViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "Cabinet",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Transform.translate(
              offset: Offset(0, 7),
              child: PopupMenuButton(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                ),
                offset: const Offset(0, 10),
                elevation: 10,
                shadowColor: AppColors.bgLightBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18.r),
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(Assets.icons.popupMenu),
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry>[
                    PopupMenuItem(
                        onTap: () async {
                          await Navigator.pushNamed(context, Routes.updateProfilePage);
                          viewModel.getUserDetails();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.icons.edit3),
                            const SizedBox(
                              width: 8,
                            ),
                            Text('edit'.tr(),
                                style: AppTextStyle.font13W500Normal
                                    .copyWith(color: AppColors.darkGray, fontSize: 14)),
                          ],
                        )),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                        onTap: () async {
                          await viewModel.logOut();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.icons.logOut),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'exit'.tr(),
                              style: AppTextStyle.font13W500Normal
                                  .copyWith(color: AppColors.red, fontSize: 14),
                            ),
                          ],
                        )),
                  ];
                },
              ),
            ),
          )
        ],
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: AppDecoration.bannerDecor
                .copyWith(color: AppColors.bgLightBlue.withValues(alpha: 0.1), boxShadow: []),
            child: Column(
              children: [
                UserDetailsBar(
                  viewModel: viewModel,
                ),
                const SizedBox(
                  height: 24,
                ),
                UserStatisticsWithNumbers(
                  viewModel: viewModel,
                ),
                const SizedBox(
                  height: 24,
                ),
                UserStatisticsWithPersentage(
                  viewModel: viewModel,
                ),
                const SizedBox(
                  height: 24,
                ),
                detailItem(
                    title: "phone".tr(),
                    detail: (viewModel.profileRepository.userCabinet.user?.phone.toString() ?? "")
                        .phoneFormatter),
                const SizedBox(
                  height: 8,
                ),
                detailItem(
                    title: "status".tr(),
                    detail: viewModel.profileRepository.userCabinet.tariff?.name?.en ?? ""),
                const SizedBox(
                  height: 8,
                ),
                detailItem(
                    title: "gender".tr(),
                    detail: viewModel.profileRepository.userCabinet.user?.gender.localeName ?? ""),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  ProfilePageViewModel viewModelBuilder(BuildContext context) {
    return ProfilePageViewModel(
      context: context,
      profileRepository: locator.get(),
      localViewModel: locator.get(),
      sharedPreferenceHelper: locator.get(),
      wordEntityRepository: locator.get(),
      netWorkChecker: locator.get(),
    );
  }

  Container detailItem({String title = "", String detail = ""}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColors.vibrantBlue.withValues(alpha: 0.15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.charcoal),
          ),
          Text(
            detail,
            style: AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.blue),
          )
        ],
      ),
    );
  }
}

class UserStatisticsWithPersentage extends StatelessWidget {
  const UserStatisticsWithPersentage({super.key, required this.viewModel});

  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return viewModel.isBusy(tag: viewModel.getGetUserTag) ? shimmer() : _buildContent();
  }

  Widget shimmer() {
    return ShimmerWidget(child: _buildContent());
  }

  Row _buildContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(percent: viewModel.winRate, title: "win_rate".tr()),
        const SizedBox(
          width: 12,
        ),
        item(percent: viewModel.gameAccuracy, title: "game_accuracy".tr()),
        const SizedBox(
          width: 12,
        ),
        item(
            percent: viewModel.averageTimeValue,
            percentSign: viewModel.averageTimeSymbol,
            title: "average_time".tr()),
        const SizedBox(
          width: 12,
        ),
        item(percent: viewModel.bestTime, percentSign: " s", title: "best_time".tr()),
      ],
    );
  }

  Widget item({String? title, String? percentSign, int? percent}) {
    return Expanded(
      child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppColors.blue,
        radius: 28,
        backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
        center: Text(
          percent != null ? "$percent${percentSign ?? "%"}" : "",
          style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue, fontSize: 16),
        ),
        footer: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            textAlign: TextAlign.center,
            title ?? "",
            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 11),
          ),
        ),
      ),
    );
  }
}

class UserDetailsBar extends StatelessWidget {
  const UserDetailsBar({super.key, required this.viewModel});

  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return viewModel.isBusy(tag: viewModel.getGetUserTag) ? shimmer() : _buildContent();
  }

  Row _buildContent() {
    return Row(
      children: [
        if (!viewModel.hasUser || !viewModel.hasUserPhoto)
          SvgPicture.asset(
            Assets.icons.userAvatar,
            height: 56,
            width: 56,
          )
        else
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.white)),
            child: CircleAvatar(
              radius: 28.r,
              backgroundImage: NetworkImage(Uri.encodeFull(viewModel.userPhoto)),
              backgroundColor: Colors.transparent,
            ),
          ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                viewModel.userName,
                style: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue, fontSize: 18),
              ),
              Transform.translate(
                offset: Offset(-4, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () async {
                      if (viewModel.hasUser) {
                        await Clipboard.setData(ClipboardData(
                            text: viewModel.profileRepository.userCabinet!.user!.id!.toString()));
                        if (navigatorKey.currentContext!.mounted) {
                          ScaffoldMessenger.of(navigatorKey.currentContext!)
                              .showSnackBar(const SnackBar(
                            content: Text("Value copied to clipboard"),
                          ));
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "ID: ${viewModel.profileRepository.userCabinet?.user?.id ?? ""}",
                            style: AppTextStyle.font13W500Normal
                                .copyWith(color: AppColors.blue, fontSize: 12),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(Assets.icons.documentCopy)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  (viewModel.userCurrentLevel).toString(),
                  style:
                      AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 14),
                ),
                const SizedBox(
                  width: 9,
                ),
                SvgPicture.asset(
                  Assets.icons.verify,
                  colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  (viewModel.userStars).toString(),
                  style:
                      AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 14),
                ),
                const SizedBox(
                  width: 9,
                ),
                SvgPicture.asset(
                  Assets.icons.star,
                  colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget shimmer() => ShimmerWidget(child: _buildContent());
}

class UserStatisticsWithNumbers extends StatelessWidget {
  const UserStatisticsWithNumbers({super.key, required this.viewModel});

  final ProfilePageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return viewModel.isBusy(tag: viewModel.getGetUserTag) ? shimmer() : _buildContent();
  }

  Padding _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          item(
              value: viewModel.threeStarWins, subtitle: "games".tr(), itemName: "3_star_wins".tr()),
          divider,
          item(value: viewModel.dailyRecord, subtitle: "words".tr(), itemName: "daily_record".tr()),
          divider,
          item(
              value: viewModel.weeklyRecord,
              subtitle: "words".tr(),
              itemName: "weekly_record".tr()),
          divider,
          item(
              value: viewModel.monthlyRecord,
              subtitle: "words".tr(),
              itemName: "monthly_record".tr()),
        ],
      ),
    );
  }

  Widget shimmer() => Shimmer.fromColors(
        baseColor: AppColors.bgLightBlue.withValues(alpha: 0.3),
        highlightColor: AppColors.bgLightBlue.withValues(alpha: 0.7),
        enabled: true,
        period: const Duration(seconds: 2),
        child: _buildContent(),
      );

  SizedBox get divider {
    return const SizedBox(
      width: 38,
    );
  }

  Widget item({int? value, String? subtitle, String? itemName}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "${value ?? 0}",
            textAlign: TextAlign.center,
            style: AppTextStyle.font28W600Normal.copyWith(color: AppColors.blue, fontSize: 24),
          ),
          Text(
            subtitle ?? "",
            textAlign: TextAlign.center,
            style:
                AppTextStyle.font13W500Normal.copyWith(fontSize: 8, color: AppColors.textDisabled),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            itemName ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 11),
          )
        ],
      ),
    );
  }
}
