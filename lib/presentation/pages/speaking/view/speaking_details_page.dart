import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jbaza/jbaza.dart';
import 'package:selectable/selectable.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/presentation/widgets/loading_widget.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../../config/constants/assets.dart';
import '../../../../config/constants/constants.dart';
import '../../../components/catalog_item.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/speaking_detail_page_viewmodel.dart';

class SpeakingDetailPage extends ViewModelBuilderWidget<SpeakingDetailPageViewModel> {
  SpeakingDetailPage({super.key});

  @override
  void onViewModelReady(SpeakingDetailPageViewModel viewModel) {
    FocusScope.of(viewModel.context!).unfocus();
    viewModel.localViewModel.showInterstitialAd();
    viewModel.getSpeakingWordList(null);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, SpeakingDetailPageViewModel viewModel, Widget? child) {
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
        onWillPop: () => viewModel.goBack(),
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: CustomAppBar(
            leadingIcon: Assets.icons.arrowLeft,
            onTap: () => viewModel.goBack(),
            isSearch: true,
            onChange: (value) => viewModel.getSpeakingWordList(value),
            title: viewModel.homeRepository.timelineModel.speaking!.word ?? "",
          ),
          body: viewModel.isSuccess(tag: viewModel.getSpeakingListTag)
              ? ListView.builder(
                  itemCount: viewModel.categoryRepository.speakingWordsList.length,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 75.h),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var element = viewModel.categoryRepository.speakingWordsList[index];
                    return CatalogItem(
                        firstText: element.word ?? "Unknown",
                        translateText: element.translate ?? "",
                        onTap: () => viewModel.tts(element.word));
                  },
                )
              : const Center(child: LoadingWidget()),
        ),
      ),
    );
    // return Selectable(
    //   popupMenuItems: [
    //     SelectableMenuItem(
    //         title: "Search",
    //         isEnabled: (controller) => controller!.isTextSelected,
    //         icon: Icons.search_rounded,
    //         handler: (controller) {
    //           if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
    //             viewModel.localViewModel.goByLink(controller.getSelection()!.text ?? "");
    //           }
    //           return true;
    //         }),
    //     SelectableMenuItem(type: SelectableMenuItemType.copy, icon: Icons.copy_outlined),
    //     SelectableMenuItem(
    //         title: "Share",
    //         isEnabled: (controller) => controller!.isTextSelected,
    //         icon: Icons.share_rounded,
    //         handler: (controller) {
    //           if (controller != null && (controller.getSelection()!.text ?? "").isNotEmpty) {
    //             viewModel.localViewModel.shareWord(controller.getSelection()!.text!);
    //           }
    //           return true;
    //         }),
    //   ],
    //   child: WillPopScope(
    //     onWillPop: () => viewModel.goBack(),
    //     child: Scaffold(
    //       drawerEnableOpenDragGesture: false,
    //       backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
    //       appBar: CustomAppBar(
    //         leadingIcon: Assets.icons.arrowLeft,
    //         onTap: () => viewModel.goBack(),
    //         isSearch: false,
    //         title: "speaking".tr(),
    //       ),
    //       body: ListView(
    //         padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 16.h, bottom: 75.h),
    //         shrinkWrap: true,
    //         physics: const BouncingScrollPhysics(),
    //         children: [
    //           Column(mainAxisSize: MainAxisSize.min, children: [
    //             Container(
    //               decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
    //               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Center(
    //                     child: Text(
    //                       viewModel.getSpeaking() ?? "Unknown",
    //                       style: AppTextStyle.font17W600Normal.copyWith(
    //                           color: isDarkTheme ? AppColors.white : AppColors.darkGray,
    //                           fontSize: locator<LocalViewModel>().fontSize),
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                   Padding(
    //                     padding: EdgeInsets.only(top: 20.h),
    //                     child: viewModel.isSuccess(tag: viewModel.getSpeakingDetailsTag)
    //                         ? HtmlWidget(
    //                             viewModel.categoryRepository.speakingDetailModel.body!
    //                                 .replaceAll("\n", "")
    //                                 .replaceAll("\n\n", ""),
    //                             textStyle: AppTextStyle.font15W400NormalHtml.copyWith(
    //                               fontSize: locator<LocalViewModel>().fontSize - 2,
    //                               color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray,
    //                             ),
    //                           )
    //                         : const LoadingWidget(color: AppColors.paleBlue, width: 2),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ]),
    //           ValueListenableBuilder(
    //             valueListenable: viewModel.localViewModel.isNetworkAvailable,
    //             builder: (BuildContext context, value, Widget? child) {
    //               return viewModel.localViewModel.banner != null && value as bool
    //                   ? Container(
    //                       margin: EdgeInsets.only(top: 16.h),
    //                       decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
    //                       height: viewModel.localViewModel.banner!.size.height * 1.0,
    //                       child: AdWidget(
    //                         ad: viewModel.localViewModel.banner!..load(),
    //                       ))
    //                   : const SizedBox.shrink();
    //             },
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  SpeakingDetailPageViewModel viewModelBuilder(BuildContext context) {
    return SpeakingDetailPageViewModel(
        context: context,
        homeRepository: locator.get(),
        categoryRepository: locator.get(),
        localViewModel: locator.get());
  }
}
