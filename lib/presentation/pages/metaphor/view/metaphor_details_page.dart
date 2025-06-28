import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:jbaza/jbaza.dart';
import 'package:selectable/selectable.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/presentation/pages/metaphor/viewmodel/metaphor_detail_page_viewmodel.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/app_decoration.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../../data/viewmodel/local_viewmodel.dart';
import '../../../widgets/banner_ad_widget.dart';
import '../../../widgets/custom_app_bar.dart';

class MetaphorDetailPage extends ViewModelBuilderWidget<MetaphorDetailPageViewModel> {
  MetaphorDetailPage({super.key});

  SelectableController textSelectionControls = SelectableController();

  @override
  void onViewModelReady(MetaphorDetailPageViewModel viewModel) {
    FocusScope.of(viewModel.context!).unfocus();
    viewModel.localViewModel.showInterstitialAd();
    viewModel.getMetaphorDetails();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MetaphorDetailPageViewModel viewModel, Widget? child) {
    return Selectable(
      popupMenuItems: [
        SelectableMenuItem(
            title: "Search",
            isEnabled: (controller) => controller!.isTextSelected,
            icon: Icons.search_rounded,
            handler: (controller) {
              if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
                viewModel.localViewModel.goByLink(controller.getSelection()!.text ?? "");
              }
              return true;
            }),
        SelectableMenuItem(type: SelectableMenuItemType.copy, icon: Icons.copy_outlined),
        SelectableMenuItem(
            title: "Share",
            isEnabled: (controller) => controller!.isTextSelected,
            icon: Icons.share_rounded,
            handler: (controller) {
              if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
                viewModel.localViewModel.shareWord(controller.getSelection()!.text!);
              }
              return true;
            }),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (textSelectionControls.isTextSelected) {
            textSelectionControls.deselect();
          } else {
            viewModel.goBack();
          }
          return false;
        },
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: CustomAppBar(
            leadingIcon: Assets.icons.arrowLeft,
            onTap: () => viewModel.goBack(),
            isSearch: false,
            title: "metaphor".tr(),
          ),
          body: ListView(
            padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 16.h, bottom: 75.h),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  decoration:
                      isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          viewModel.getMetaphor() ?? "Unknown",
                          style: AppTextStyle.font17W600Normal.copyWith(
                              color: isDarkTheme ? AppColors.white : AppColors.darkGray,
                              fontSize: locator<LocalViewModel>().fontSize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: viewModel.isSuccess(tag: viewModel.getMetaphorDetailsTag)
                            ? HtmlWidget(
                                viewModel.categoryRepository.metaphorDetailModel.mBody!
                                    .replaceAll("<br>", "")
                                    .replaceAll("<p>", "")
                                    .replaceAll("</p>", "<br>"),
                                textStyle: AppTextStyle.font15W400NormalHtml.copyWith(
                                    fontSize: locator<LocalViewModel>().fontSize - 2,
                                    color: isDarkTheme ? AppColors.lightGray : null),
                              )
                            : const LoadingWidget(color: AppColors.paleBlue, width: 2),
                      ),
                    ],
                  ),
                )
              ]),
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  MetaphorDetailPageViewModel viewModelBuilder(BuildContext context) {
    return MetaphorDetailPageViewModel(
      context: context,
      homeRepository: locator.get(),
      categoryRepository: locator.get(),
      localViewModel: locator.get(),
    );
  }
}
