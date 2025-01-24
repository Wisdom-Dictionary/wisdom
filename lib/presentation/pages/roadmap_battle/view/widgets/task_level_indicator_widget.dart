import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';

class FlagIndicatorWidget extends StatelessWidget {
  const FlagIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.blue,
        border: Border.all(color: AppColors.borderWhite, width: 2),
      ),
      child: Column(
        children: [
          SvgPicture.asset(Assets.icons.flag),
          SizedBox(height: 4,),
          Text(
            "17",
            style: AppTextStyle.font13W500Normal
                .copyWith(fontSize: 14, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

class TaskLevelIndicatorWidget extends StatelessWidget {
  const TaskLevelIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskLevelStarsIndicator(),
        SizedBox(
          height: 4,
        ),
        SvgPicture.asset(Assets.icons.userAvatar),
        Transform.translate(
          offset: Offset(0, -15),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
            // height: 21.h,
            decoration: BoxDecoration(
                color: AppColors.blue,
                border: Border.all(color: AppColors.borderWhite, width: 2),
                borderRadius: BorderRadius.circular(1000)),
            child: Text(
              "1-20",
              style: AppTextStyle.font13W500Normal
                  .copyWith(fontSize: 14, color: AppColors.white),
            ),
          ),
        )
      ],
    );
  }
}

class InactiveLevelIndicator extends StatelessWidget {
  const InactiveLevelIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TaskLevelStarsIndicator(),
        SizedBox(
          height: 4,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.5.w, vertical: 4.h),
          decoration: BoxDecoration(
              color: AppColors.lightBackground,
              border: Border.all(color: AppColors.white, width: 2),
              borderRadius: BorderRadius.circular(64)),
          child: Column(
            children: [
              Text(
                "20-40",
                style: AppTextStyle.font13W500Normal
                    .copyWith(fontSize: 14, color: AppColors.textDisabled),
              ),
              SizedBox(
                height: 8,
              ),
              SvgPicture.asset(Assets.icons.lock),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskLevelStarsIndicator extends StatelessWidget {
  const TaskLevelStarsIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.translate(
            offset: Offset(1, 4),
            child: SvgPicture.asset(Assets.icons.starInactive)),
        SvgPicture.asset(Assets.icons.starInactive),
        Transform.translate(
            offset: Offset(-1, 4),
            child: SvgPicture.asset(Assets.icons.starInactive)),
      ],
    );
  }
}
