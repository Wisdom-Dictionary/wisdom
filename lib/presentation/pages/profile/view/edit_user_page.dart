import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({super.key});

  bool isEmail(String value) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: NewCustomAppBar(
        title: "Cabinet",
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                Text(
                  "Edit",
                  style:
                      AppTextStyle.font17W600Normal.copyWith(color: AppColors.blue, fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32)),
                  child: TextFormField(
                    onChanged: (value) {},
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style:
                        AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Ism",
                        hintStyle: AppTextStyle.font13W500Normal
                            .copyWith(fontSize: 14, color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32)),
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style:
                        AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Familiya",
                        hintStyle: AppTextStyle.font13W500Normal
                            .copyWith(fontSize: 14, color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(32)),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                    style:
                        AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
                    decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: AppTextStyle.font13W500Normal
                            .copyWith(fontSize: 14, color: AppColors.blue.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 18)),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                        context: context, firstDate: DateTime(1900), lastDate: DateTime.now());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15.5),
                    decoration: BoxDecoration(
                        color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(32)),
                    child: Row(
                      children: [
                        SvgPicture.asset(Assets.icons.calendar),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "kk.oo.yyyy",
                          style: AppTextStyle.font13W500Normal
                              .copyWith(fontSize: 14, color: AppColors.blue.withValues(alpha: 0.5)),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: WButton(
                        height: 41,
                        title: "Male",
                        onTap: () {},
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: WButton(
                        height: 41,
                        title: "Female",
                        titleColor: AppColors.blue,
                        color: AppColors.bgLightBlue.withValues(alpha: 0.1),
                        onTap: () {},
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          WButton(
            margin: EdgeInsets.all(16),
            title: "save".tr(),
            onTap: () {},
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
