import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/my_contacts/contact_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/profile/view/edit_user_page.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class ContactDetailsPage extends StatelessWidget {
  ContactDetailsPage({super.key, Object? data})
      : contactItemData = (data is Map<String, dynamic>)
            ? ContactModel.fromJson(data)
            : throw ArgumentError("Invalid data format");
  final ContactModel contactItemData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "Cabinet",
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: AppDecoration.bannerDecor.copyWith(
                color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                boxShadow: []),
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
                  title: "follow".tr(),
                  onTap: () {},
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ContactDetailsBar extends StatelessWidget {
  const ContactDetailsBar({super.key, required this.contactItemData});
  final ContactModel contactItemData;
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
                style: AppTextStyle.font17W600Normal
                    .copyWith(color: AppColors.blue, fontSize: 18),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "Rank: Major",
                style: AppTextStyle.font13W500Normal
                    .copyWith(color: AppColors.blue, fontSize: 12),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: AppColors.blue, borderRadius: BorderRadius.circular(37)),
          child: Row(
            children: [
              Text(
                (contactItemData.userCurrentLevel??0).toString(),
                style: AppTextStyle.font13W500Normal
                    .copyWith(color: AppColors.yellow, fontSize: 14),
              ),
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset(
                Assets.icons.verify,
                colorFilter:
                    const ColorFilter.mode(AppColors.yellow, BlendMode.srcIn),
              )
            ],
          ),
        )
      ],
    );
  }
}

class UserStatisticsWithPersentage extends StatelessWidget {
  const UserStatisticsWithPersentage(
      {super.key, required this.contactItemData});

  final ContactModel contactItemData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(
            percent: contactItemData.statistics?.winRate ?? 0,
            title: "win_rate".tr()),
        item(
            percent: contactItemData.statistics?.gameAccuracy ?? 0,
            title: "game_accuracy".tr()),
        item(
            percent: contactItemData.statistics?.averageTime ?? 0,
            percentSign: " s",
            title: "average_time".tr()),
        item(
            percent: contactItemData.statistics?.bestTime ?? 0,
            percentSign: " s",
            title: "best_time".tr()),
      ],
    );
  }

  CircularPercentIndicator item(
      {String? title, String? percentSign, int? percent}) {
    return CircularPercentIndicator(
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: AppColors.blue,
      radius: 28,
      backgroundColor: AppColors.vibrantBlue.withValues(alpha: 0.15),
      percent: (percent ?? 0) / 100,
      center: Text(
        percent != null ? "$percent${percentSign ?? "%"}" : "",
        style: AppTextStyle.font15W600Normal
            .copyWith(color: AppColors.blue, fontSize: 16),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          title ?? "",
          style: AppTextStyle.font13W500Normal
              .copyWith(color: AppColors.blue, fontSize: 11),
        ),
      ),
    );
  }
}

class UserDetailsBar extends StatelessWidget {
  const UserDetailsBar({
    super.key,
  });

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
                "Ali Kamilov",
                style: AppTextStyle.font17W600Normal
                    .copyWith(color: AppColors.blue, fontSize: 18),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    "ID: 37905234",
                    style: AppTextStyle.font13W500Normal
                        .copyWith(color: AppColors.blue, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  SvgPicture.asset(Assets.icons.documentCopy)
                ],
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
                  "12460",
                  style: AppTextStyle.font13W500Normal
                      .copyWith(color: AppColors.blue, fontSize: 14),
                ),
                const SizedBox(
                  width: 9,
                ),
                SvgPicture.asset(
                  Assets.icons.verify,
                  colorFilter:
                      const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                )
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  "2301",
                  style: AppTextStyle.font13W500Normal
                      .copyWith(color: AppColors.blue, fontSize: 14),
                ),
                const SizedBox(
                  width: 9,
                ),
                SvgPicture.asset(
                  Assets.icons.star,
                  colorFilter:
                      const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class UserStatisticsWithNumbers extends StatelessWidget {
  const UserStatisticsWithNumbers({super.key, required this.contactItemData});
  final ContactModel contactItemData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          item(
              value: contactItemData.statistics?.threeStarWins ?? 0,
              subtitle: "games".tr(),
              itemName: "3_star_wins".tr()),
          divider,
          item(
              value: contactItemData.statistics?.dailyRecord ?? 0,
              subtitle: "words".tr(),
              itemName: "daily_record".tr()),
          divider,
          item(
              value: contactItemData.statistics?.weeklyRecord ?? 0,
              subtitle: "words".tr(),
              itemName: "weekly_record".tr()),
          divider,
          item(
              value: contactItemData.statistics?.monthlyRecord ?? 0,
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
            style: AppTextStyle.font28W600Normal
                .copyWith(color: AppColors.blue, fontSize: 24),
          ),
          Text(
            subtitle ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal
                .copyWith(fontSize: 8, color: AppColors.textDisabled),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            itemName ?? "",
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal
                .copyWith(color: AppColors.blue, fontSize: 11),
          )
        ],
      ),
    );
  }
}
