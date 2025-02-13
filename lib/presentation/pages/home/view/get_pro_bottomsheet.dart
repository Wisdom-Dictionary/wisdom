import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_decoration.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/extensions/num_extension.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/tariffs_model.dart';
import 'package:wisdom/presentation/components/pro_info.dart';
import 'package:wisdom/presentation/pages/profile/viewmodel/getting_pro_page_viewmodel.dart';

import '../../../../config/constants/constants.dart';
import '../../profile/widgets/pro_version_button.dart';

void showGetProBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    builder: (context) => GetProBottomsheet(),
  );
}

class GetProBottomsheet extends ViewModelBuilderWidget<GettingProPageViewModel> {
  GetProBottomsheet({super.key});

  @override
  void onViewModelReady(GettingProPageViewModel viewModel) {
    viewModel.getTariffs();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, GettingProPageViewModel viewModel, Widget? child) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _sheetIndicator(),
          const Gap(20),
          SvgPicture.asset(
            isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
            height: 52.h,
            fit: BoxFit.scaleDown,
          ),
          Container(
            decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
            padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Text(
                    'get_pro2'.tr(),
                    style: AppTextStyle.font17W500Normal.copyWith(color: AppColors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
                ProInfo(label: "get_pro3".tr()),
                ProInfo(label: "get_pro4".tr()),
                ProInfo(label: "get_pro5".tr()),
                ProInfo(label: "get_pro6".tr()),
                ProInfo(label: "get_pro7".tr()),
                ProInfo(label: "get_pro8".tr()),
                ProInfo(label: "get_pro9".tr()),
                ProInfo(label: "get_pro10".tr()),
                ProInfo(label: "get_pro11".tr()),
                ProInfo(label: "get_pro12".tr()),
                viewModel.isSuccess(tag: viewModel.getTariffsTag)
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: viewModel.profileRepository.tariffsModel.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          var item = viewModel.profileRepository.tariffsModel[index];
                          return buildRadioListTile(context, item, viewModel);
                        },
                      )
                    : const SizedBox.shrink(),
                const Gap(20),
                ProVersionButton(
                  onTap: () {
                    viewModel.onBuyPremiumPressed();
                  },
                  isVisible: true,
                  tariffsModel: viewModel.tariffsModel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sheetIndicator() {
    return Container(
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: 35,
      decoration: BoxDecoration(
        color: AppColors.sheetIndicatorColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget buildRadioListTile(
    BuildContext context,
    TariffsModel item,
    GettingProPageViewModel viewModel,
  ) {
    return RadioListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ((context.locale.toString() == "en_US" ? item.name!.en : item.name!.uz) ??
                    "Contact with developers")
                .toUpperCase(),
            style: AppTextStyle.font15W500Normal
                .copyWith(color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray),
          ),
          const Gap(12),
          if (item.price != null)
            Text(
              LocaleKeys.sum.tr(args: [item.price.toMoneyFormat]),
              style: AppTextStyle.font15W500Normal.copyWith(
                color: isDarkTheme ? AppColors.lightGray : AppColors.darkGray,
              ),
            ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
      value: item.id.toString(),
      groupValue: viewModel.tariffsValue,
      onChanged: (value) {
        viewModel.tariffsValue = value.toString();
        viewModel.notifyListeners();
      },
    );
  }

  @override
  GettingProPageViewModel viewModelBuilder(BuildContext context) {
    return GettingProPageViewModel(
      context: context,
      localViewModel: locator.get(),
      profileRepository: locator.get(),
      sharedPreferenceHelper: locator.get(),
    );
  }
}
