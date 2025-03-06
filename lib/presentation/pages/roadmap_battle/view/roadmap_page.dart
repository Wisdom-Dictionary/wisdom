import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/roadmap_custom_painter.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/life_status_bar.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
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
        body: Stack(
      children: [
        ExampleRoadMap(
          viewModel: viewModel,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NewCustomAppBar(
            height: 63.h,
            hasLeading: false,
            child: RoadmapAppBarContent(
              viewModel: viewModel,
            ),
          ),
        ),
      ],
    ));
  }

  @override
  RoadMapViewModel viewModelBuilder(BuildContext context) {
    return RoadMapViewModel(context: context);
  }
}

class RoadmapAppBarContent extends StatelessWidget {
  const RoadmapAppBarContent({super.key, required this.viewModel});
  final RoadMapViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          scoreInfo((viewModel.userDetailsModel?.statistics?.userStars ?? 0).toString(),
              SvgPicture.asset(Assets.icons.star)),
          scoreInfo((viewModel.userDetailsModel?.userCurrentLevel ?? 0).toString(),
              SvgPicture.asset(Assets.icons.verify)),
          const LifeStatusBar()
        ],
      ),
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
