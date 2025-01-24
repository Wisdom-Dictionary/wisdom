import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/task_level_indicator_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/roadmap_viewmodel.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class RoadmapPage extends ViewModelBuilderWidget<RoadMapViewModel> {
  RoadmapPage({super.key});

  @override
  void onViewModelReady(RoadMapViewModel viewModel) {
    // viewModel.getLevels();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
      BuildContext context, RoadMapViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: NewCustomAppBar(
        child: const RoadmapAppBarContent(),
      ),
      body: viewModel.isSuccess(tag: viewModel.getLevelsTag)
          ? const Stack(
              children: [
                Positioned.fill(child: RoadMapContent()),
                Positioned(top: 0, right: 10, child: FlagIndicatorWidget()),
              ],
            )
          : LoadingWidget(),
    );
  }

  @override
  RoadMapViewModel viewModelBuilder(BuildContext context) {
    return RoadMapViewModel(context: context);
  }
}

class RoadMapContent extends StatelessWidget {
  const RoadMapContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        reverse: true,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.images.roadmapBattleBackground,
                repeat: ImageRepeat.repeat,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backgroundGradient(topGradient()),
                backgroundGradient(bottomGradient())
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Transform.translate(
                        offset: const Offset(0, 115),
                        child: SvgPicture.asset(Assets.images.roadmapWay3)),
                    Transform.translate(
                        offset: const Offset(0, 40),
                        child: SvgPicture.asset(Assets.images.roadmapWay2)),
                    Transform.translate(
                        offset: const Offset(14, -35),
                        child: SvgPicture.asset(Assets.images.roadmapWay)),
                  ],
                ),
              ),
            ),
            const Positioned(
                bottom: 130, right: 100, child: TaskLevelIndicatorWidget()),
            const Positioned(
                bottom: 160, left: 100, child: InactiveLevelIndicator())
          ],
        ),
      ),
    );
  }

  Container backgroundGradient(LinearGradient gradient) {
    return Container(
      height: 137,
      decoration: BoxDecoration(gradient: gradient),
    );
  }

  LinearGradient topGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0xFFE2F2F8),
          Color(0x00F0F8FB),
        ]);
  }

  LinearGradient bottomGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0x00F0F8FB),
          Color(0xFFE2F2F8),
        ]);
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
            lifeStatusBar(),
            Padding(
              padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 4.h),
              child: Material(
                borderRadius: BorderRadius.circular(21.r),
                color: AppColors.white,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(21.r),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    height: 19.h,
                    child: Center(
                      child: Text(
                        "claim".tr(),
                        style: AppTextStyle.font13W500Normal
                            .copyWith(color: AppColors.blue),
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

  Row lifeStatusBar() {
    return Row(
      children: [
        SvgPicture.asset(Assets.icons.heart),
        SvgPicture.asset(Assets.icons.heart),
        SvgPicture.asset(
          Assets.icons.heartSlash,
          colorFilter: ColorFilter.mode(
              AppColors.white.withOpacity(0.5), BlendMode.srcIn),
        ),
      ],
    );
  }

  Row scoreInfo(String title, Widget icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style:
              AppTextStyle.font13W400Normal.copyWith(color: AppColors.yellow),
        ),
        const SizedBox(
          width: 12,
        ),
        icon
      ],
    );
  }
}
