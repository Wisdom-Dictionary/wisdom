import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/my_contacts/viewmodel/contact_details_viewmodel.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class ContactDetailsPage extends ViewModelBuilderWidget<ContactDetailsViewModel> {
  ContactDetailsPage({super.key, Object? data})
      : contactItemData = (data is Map<String, dynamic>)
            ? UserDetailsModel.fromJson(data)
            : throw ArgumentError("Invalid data format");
  final UserDetailsModel contactItemData;
  @override
  void onViewModelReady(ContactDetailsViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.setFollowStatus(contactItemData.followed ?? true);
  }

  @override
  Widget builder(BuildContext context, ContactDetailsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "cabinet".tr(),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: AppDecoration.bannerDecor
                .copyWith(color: AppColors.bgLightBlue.withValues(alpha: 0.1), boxShadow: []),
            child: Column(
              children: [
                ContactDetailsBar(
                  contactItemData: contactItemData,
                ),
                const SizedBox(
                  height: 24,
                ),
                UserStatisticsWithNumbers(
                  contactItemData: contactItemData,
                ),
                const SizedBox(
                  height: 24,
                ),
                UserStatisticsWithPersentage(
                  contactItemData: contactItemData,
                ),
                const SizedBox(
                  height: 24,
                ),
                WButton(
                  isLoading: viewModel.isBusy(tag: viewModel.getMyContactFollowTag),
                  title: viewModel.isFollowed ? "unfollow".tr() : "follow".tr(),
                  onTap: () {
                    viewModel.postFollowAction(
                      contactItemData.user?.id ?? 0,
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  ContactDetailsViewModel viewModelBuilder(BuildContext context) {
    return ContactDetailsViewModel(context: context);
  }
}

class ContactDetailsBar extends StatelessWidget {
  const ContactDetailsBar({super.key, required this.contactItemData});
  final UserDetailsModel contactItemData;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(Assets.icons.userAvatar),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                contactItemData.user?.name ?? "",
                style: AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue, fontSize: 18),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "${"rank".tr()}: ${contactItemData.rank?.name ?? ""}",
                style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.circular(37)),
          child: Row(
            children: [
              Text(
                (contactItemData.userCurrentLevel ?? 0).toString(),
                style:
                    AppTextStyle.font13W500Normal.copyWith(color: AppColors.yellow, fontSize: 14),
              ),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset(
                Assets.icons.verify,
                colorFilter: const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
              )
            ],
          ),
        )
      ],
    );
  }
}

class UserStatisticsWithPersentage extends StatelessWidget {
  const UserStatisticsWithPersentage({super.key, required this.contactItemData});

  final UserDetailsModel contactItemData;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(percent: contactItemData.winRate, title: "win_rate".tr()),
        const SizedBox(
          width: 12,
        ),
        item(percent: contactItemData.gameAccuracy, title: "game_accuracy".tr()),
        const SizedBox(
          width: 12,
        ),
        item(
            percent: contactItemData.averageTimeValue,
            percentSign: contactItemData.averageTimeSymbol,
            title: "average_time".tr()),
        const SizedBox(
          width: 12,
        ),
        item(
            percent: contactItemData.bestTimeValue,
            percentSign: contactItemData.bestTimeSymbol,
            title: "best_time".tr()),
      ],
    );
  }

  String formatMilliseconds(int milliseconds) {
    int totalSeconds = (milliseconds / 1000).floor();
    int minutes = (totalSeconds / 60).floor();
    int seconds = totalSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  Widget item({String? title, String? percentSign, int? percent}) {
    return Expanded(
      child: CircularPercentIndicator(
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: AppColors.blue,
        radius: 28,
        backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
        // percent: (percent ?? 0) / 100,
        percent: 0,
        center: Text(
          percent != null ? "$percent${percentSign ?? "%"}" : "",
          textAlign: TextAlign.center,
          style: AppTextStyle.font15W600Normal.copyWith(color: AppColors.blue, fontSize: 16),
        ),
        footer: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue, fontSize: 11),
          ),
        ),
      ),
    );
  }
}

class UserStatisticsWithNumbers extends StatelessWidget {
  const UserStatisticsWithNumbers({super.key, required this.contactItemData});
  final UserDetailsModel contactItemData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          item(
              value: contactItemData.threeStarWins,
              subtitle: "games".tr(),
              itemName: "3_star_wins".tr()),
          divider,
          item(
              value: contactItemData.dailyRecord,
              subtitle: "words".tr(),
              itemName: "daily_record".tr()),
          divider,
          item(
              value: contactItemData.weeklyRecord,
              subtitle: "words".tr(),
              itemName: "weekly_record".tr()),
          divider,
          item(
              value: contactItemData.monthlyRecord,
              subtitle: "words".tr(),
              itemName: "monthly_record".tr()),
        ],
      ),
    );
  }

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
