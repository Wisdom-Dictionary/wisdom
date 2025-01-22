import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/domain/http_is_success.dart';

class SearchWordItem extends StatelessWidget {
  const SearchWordItem({
    super.key,
    required this.firstText,
    required this.secondText,
    this.thirdText,
    required this.onTap,
    required this.star,
  });

  final String firstText;
  final String secondText;
  final String? thirdText;
  final Function() onTap;
  final String star;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: SizedBox(
        height: 52.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 34.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: AppTextStyle.font15W500Normal
                                .copyWith(color: isDarkTheme ? AppColors.white : AppColors.darkGray),
                            text: firstText,
                            children: [
                              TextSpan(
                                  text: '   $secondText',
                                  style: AppTextStyle.font15W500Normal
                                      .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.blue)),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (thirdText ?? "").isNotEmpty,
                          child: Text(
                            replaceSame(thirdText ?? "", firstText),
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.lightGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                star != "0"
                    ? SizedBox(
                        height: 48.h,
                        width: 48.h,
                        child: Padding(
                          padding: EdgeInsets.only(right: 20.w),
                          child: SvgPicture.asset(
                            star.findRank,
                            height: 24.h,
                            width: 24.h,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 48.h,
                      ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Divider(
                color: isDarkTheme ? AppColors.darkForm : AppColors.borderWhite,
                height: 1,
                thickness: 0.5,
              ),
            )
          ],
        ),
      ),
    );
  }

  String replaceSame(String s1, String target) {
    return s1.replaceAll("$target,", "").replaceAll(",$target", "").replaceAll(target, "");
  }
}
