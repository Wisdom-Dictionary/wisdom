import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/roadmap_custom_painter.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/life_status_bar.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/roadmap_viewmodel.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class RoadmapPage extends ViewModelBuilderWidget<RoadMapViewModel> {
  RoadmapPage({super.key});

  @override
  void onViewModelReady(RoadMapViewModel viewModel) {
    viewModel.getLevels();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, RoadMapViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: NewCustomAppBar(
          child: const RoadmapAppBarContent(),
        ),
        body: ExampleRoadMap(
          viewModel: viewModel,
        ));
  }

  @override
  RoadMapViewModel viewModelBuilder(BuildContext context) {
    return RoadMapViewModel(context: context);
  }
}

class RoadmapAppBarContent extends StatelessWidget {
  const RoadmapAppBarContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        scoreInfo("1200", SvgPicture.asset(Assets.icons.star)),
        scoreInfo("500", SvgPicture.asset(Assets.icons.verify)),
        Column(
          children: [
            LifeStatusBar(),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 4.h),
              child: Material(
                borderRadius: BorderRadius.circular(21.r),
                color: AppColors.white,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(21.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    height: 19.h,
                    child: Center(
                      child: Text(
                        "claim".tr(),
                        style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Row scoreInfo(String title, Widget icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyle.font13W400Normal.copyWith(color: AppColors.yellow),
        ),
        const SizedBox(
          width: 12,
        ),
        icon
      ],
    );
  }
}
