import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class UserCabinetPage extends StatelessWidget {
  const UserCabinetPage({super.key});

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: PopupMenuButton(
              menuPadding: EdgeInsets.all(24),
              offset: Offset(0, 50),
              elevation: 10,
              shadowColor: AppColors.bgLightBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18.r),
              color: AppColors.white,
              child: SvgPicture.asset(Assets.icons.popupMenu),
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.updateProfilePage);
                      },
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          SvgPicture.asset(Assets.icons.edit3),
                          SizedBox(
                            width: 8,
                          ),
                          Text('Edit',
                              style: AppTextStyle.font13W500Normal.copyWith(
                                  color: AppColors.darkGray, fontSize: 14)),
                        ],
                      )),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          SvgPicture.asset(Assets.icons.logOut),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Logout',
                            style: AppTextStyle.font13W500Normal
                                .copyWith(color: AppColors.red, fontSize: 14),
                          ),
                        ],
                      )),
                ];
              },
            ),
          )
        ],
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
                const UserDetailsBar(),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Title:",
                      style: AppTextStyle.font15W600Normal
                          .copyWith(fontSize: 12, color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const UserStatisticsWithNumbers()
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Title:",
                      style: AppTextStyle.font15W600Normal
                          .copyWith(fontSize: 12, color: AppColors.black),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const UserStatisticsWithPersentage()
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                detailItem(title: "Phone", detail: "+998 91 880-95-95"),
                const SizedBox(
                  height: 8,
                ),
                detailItem(title: "Status", detail: "Premium"),
                const SizedBox(
                  height: 8,
                ),
                detailItem(title: "Gender", detail: "Male"),
              ],
            ),
          )
        ],
      ),
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
            style: AppTextStyle.font13W500Normal
                .copyWith(color: AppColors.charcoal),
          ),
          Text(
            detail,
            style: AppTextStyle.font15W600Normal
                .copyWith(fontSize: 14, color: AppColors.blue),
          )
        ],
      ),
    );
  }
}

class UserStatisticsWithPersentage extends StatelessWidget {
  const UserStatisticsWithPersentage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        item(percent: 67, title: "win rate"),
        item(percent: 37, title: "game accuracy"),
        item(percent: 56, percentSign: " s", title: "average time"),
        item(percent: 40, percentSign: " s", title: "best time"),
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
  const UserStatisticsWithNumbers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          item(value: 5, subtitle: "games", itemName: "3 star wins"),
          divider,
          item(value: 41, subtitle: "words", itemName: "daily record"),
          divider,
          item(value: 201, subtitle: "words", itemName: "weekly record"),
          divider,
          item(value: 935, subtitle: "words", itemName: "monthly record"),
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
