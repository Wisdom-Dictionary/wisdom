// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';

class MyContactsEmptyPage extends StatelessWidget {
  Widget? icon;
  String? title;
  String? description;

  MyContactsEmptyPage({
    Key? key,
    this.icon,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        icon ?? SvgPicture.asset(Assets.icons.wifiOff, height: 93,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 47, horizontal: 39),
          child: Column(
            children: [
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font28W600Normal
                      .copyWith(color: AppColors.darkGray, fontSize: 25),
                ),
              if (title != null)
                const SizedBox(
                  height: 16,
                ),
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.font17W400Normal.copyWith(
                    color: AppColors.paleGray,
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
