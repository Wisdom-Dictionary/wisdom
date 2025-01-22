import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/domain/http_is_success.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    super.key,
    required this.firstText,
    required this.secondText,
    this.thirdText,
    required this.onTap,
    required this.star,
  });

  final String firstText;
  final String secondText;
  final String star;
  final String? thirdText;
  final Function() onTap;

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
                          text: TextSpan(
                            style: AppTextStyle.font15W500Normal.copyWith(
                                color: isDarkTheme
                                    ? AppColors.white
                                    : AppColors.darkGray),
                            text: firstText.length > 20
                                ? firstText.substring(0, 20)
                                : firstText,
                            children: [
                              TextSpan(
                                  text: '   $secondText',
                                  style: AppTextStyle.font15W500Normal
                                      .copyWith(color: AppColors.paleBlue)),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Visibility(
                          visible: (thirdText ?? "").isNotEmpty,
                          child: Text(
                            thirdText ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.font13W500Normal
                                .copyWith(color: AppColors.lightGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: SizedBox(
                        height: 48.h,
                        width: 48.h,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onTap(),
                            borderRadius: BorderRadius.circular(24.r),
                            child: SvgPicture.asset(
                              Assets.icons.arrowCircleRight,
                              height: 24.h,
                              width: 24.h,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
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
}
