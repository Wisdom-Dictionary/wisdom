import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';

class MyContcatsShimmerWidget extends StatelessWidget {
  const MyContcatsShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.bgLightBlue.withValues(alpha: 0.3),
        highlightColor: AppColors.bgLightBlue.withValues(alpha: 0.7),
        enabled: true,
        period: const Duration(seconds: 2),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          itemCount: 7,
          itemBuilder: (context, index) => Container(
            padding: EdgeInsets.only(top: 13, bottom: 16, left: 18, right: 18),
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.r),
                color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.icons.userAvatar,
                  height: 35,
                  width: 35,
                ),
                SizedBox(
                  width: 11,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 30),
                        height: 17,
                        width: 150,
                        decoration: ShapeDecoration(color: AppColors.blue, shape: StadiumBorder()),
                      ),
                      SizedBox(
                        height: 4.61,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 16,
                            width: 80,
                            decoration:
                                ShapeDecoration(color: AppColors.blue, shape: StadiumBorder()),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          SvgPicture.asset(
                            Assets.icons.verify,
                            colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SvgPicture.asset(
                  Assets.icons.wifi,
                  colorFilter: ColorFilter.mode(AppColors.green, BlendMode.srcIn),
                ),
                SizedBox(
                  width: 24,
                ),
                SvgPicture.asset(
                  Assets.icons.battle,
                  colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ));
  }
}
