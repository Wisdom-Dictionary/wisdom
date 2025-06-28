import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';

class LifeStatusBar extends StatelessWidget {
  const LifeStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder(
          valueListenable: ValueNotifier<int>(context.watch<CountdownProvider>().userLife),
          builder: (context, value, child) {
            return Row(
              children: List.generate(
                context.watch<CountdownProvider>().maxUserLive,
                (index) => index <= (context.watch<CountdownProvider>().userLife - 1)
                    ? SvgPicture.asset(Assets.icons.heart)
                    : SvgPicture.asset(
                        Assets.icons.heartSlash,
                        colorFilter: ColorFilter.mode(
                            AppColors.white.withValues(alpha: 0.5), BlendMode.srcIn),
                      ),
              ),
            );
          },
        ),
        ValueListenableBuilder<int>(
          valueListenable: ValueNotifier<int>(context.watch<CountdownProvider>().remainingSeconds),
          builder: (_, value, child) {
            if (value <= 0 && !context.watch<CountdownProvider>().fullUserLives) {
              return Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 4.h),
                  child: ValueListenableBuilder(
                      valueListenable: context.watch<CountdownProvider>().status,
                      builder: (_, status, child) {
                        if (status == FormzSubmissionStatus.inProgress) {
                          return const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 0.8,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        }
                        return Material(
                          borderRadius: BorderRadius.circular(21.r),
                          color: AppColors.white,
                          child: InkWell(
                            onTap: () {
                              Provider.of<CountdownProvider>(context, listen: false).claimLives();
                            },
                            borderRadius: BorderRadius.circular(21.r),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              height: 19.h,
                              child: Center(
                                child: Text(
                                  "claim".tr(),
                                  style:
                                      AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  //  FutureBuilder(
                  //     future: context.watch<CountdownProvider>().claimLives(),
                  //     builder: (_, snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return const SizedBox(
                  //           height: 10,
                  //           width: 10,
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 0.8,
                  //             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  //             backgroundColor: Colors.transparent,
                  //           ),
                  //         );
                  //       }
                  //       return Material(
                  //         borderRadius: BorderRadius.circular(21.r),
                  //         color: AppColors.white,
                  //         child: InkWell(
                  //           onTap: () {
                  //             Provider.of<CountdownProvider>(context, listen: false).claimLives();
                  //           },
                  //           borderRadius: BorderRadius.circular(21.r),
                  //           child: Container(
                  //             padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  //             height: 19.h,
                  //             child: Center(
                  //               child: Text(
                  //                 "claim".tr(),
                  //                 style:
                  //                     AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }),
                  );
            }
            if (value.isNegative || context.watch<CountdownProvider>().remainingSeconds == 0) {
              return const Center();
            }
            return Text(
              CountdownProvider.formatTimer(value),
              style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.white, fontSize: 12),
            );
          },
        )
      ],
    );
  }
}

class LifeStatusBarPadding extends StatelessWidget {
  const LifeStatusBarPadding({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 13.h, right: 15),
        child: Align(
          alignment: Alignment.center,
          child: child,
        ));
  }
}
