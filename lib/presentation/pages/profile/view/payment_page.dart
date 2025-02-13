import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/verify_model.dart';
import 'package:wisdom/presentation/widgets/custom_app_bar.dart';

import '../../../../config/constants/constants.dart';
import '../../../../core/di/app_locator.dart';
import '../../../components/custom_banner.dart';
import '../../../widgets/my_url.dart';
import '../viewmodel/payment_page_viewmodel.dart';

class PaymentPage extends ViewModelBuilderWidget<PaymentPageViewModel> {
  PaymentPage({
    super.key,
    required this.verifyModel,
    required this.phoneNumber,
  });

  VerifyModel? verifyModel;
  String? phoneNumber;

  TextEditingController editingController = TextEditingController();

  @override
  void onViewModelReady(PaymentPageViewModel viewModel) async {
    await viewModel.init();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(
      BuildContext context, PaymentPageViewModel viewModel, Widget? child) {
    return WillPopScope(
      onWillPop: () => viewModel.goToProfile(),
      child: Scaffold(
        backgroundColor:
            isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
        appBar: CustomAppBar(
          title: 'payment'.tr(),
          onTap: () => viewModel.goToProfile(),
          leadingIcon: Assets.icons.arrowLeft,
        ),
        body: viewModel.isSuccess(tag: viewModel.subscribeSuccessfulTag)
            ? Padding(
                padding: EdgeInsets.only(top: 57.h, left: 18.w, right: 18.w),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBanner(
                        title: 'choose_payment'.tr(),
                        height: 330.h,
                        contentPadding: const EdgeInsets.only(
                            top: 30, left: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            RadioListTile(
                              title: Padding(
                                padding: EdgeInsets.only(left: 100.w),
                                child: SvgPicture.asset(
                                  Assets.images.click,
                                ),
                              ),
                              value: 'click',
                              groupValue: viewModel.radioValue,
                              onChanged: (value) {
                                viewModel.radioValue = value.toString();
                                viewModel.notifyListeners();
                              },
                            ),
                            const Divider(
                              height: 1,
                              thickness: 0.5,
                              indent: 30,
                              endIndent: 30,
                              color: AppColors.borderWhite,
                            ),
                            RadioListTile(
                              title: Padding(
                                padding: EdgeInsets.only(left: 100.w),
                                child: SvgPicture.asset(
                                  Assets.images.payme,
                                ),
                              ),
                              value: 'payme',
                              groupValue: viewModel.radioValue,
                              onChanged: (value) {
                                viewModel.radioValue = value.toString();
                                viewModel.notifyListeners();
                              },
                            ),
                            if (Platform.isIOS)
                              const Divider(
                                height: 1,
                                thickness: 0.5,
                                indent: 30,
                                endIndent: 30,
                                color: AppColors.borderWhite,
                              ),
                            if (Platform.isIOS)
                              RadioListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(left: 100.w),
                                  child: SvgPicture.asset(
                                    Assets.images.applePay,
                                  ),
                                ),
                                value: 'applePay',
                                groupValue: viewModel.radioValue,
                                onChanged: (value) {
                                  viewModel.radioValue = value.toString();
                                  viewModel.notifyListeners();
                                },
                              ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.r),
                                  color: AppColors.blue),
                              height: 45.h,
                              margin: EdgeInsets.only(top: 40.h, bottom: 12.h),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    await viewModel.onPayPressed().then((value) => exit(0));
                                  },
                                  borderRadius: BorderRadius.circular(40.r),
                                  child: Center(
                                    child: Text(
                                      'do_payment'.tr(),
                                      style: AppTextStyle.font15W500Normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  RichText(
                                    text: myUrl('Restore Purchase', '',
                                        textColor: AppColors.blue,
                                        underline: false,
                                        onTap: () => viewModel.restore()),
                                  ),
                                  RichText(
                                    text: myUrl(
                                        'Privacy', Constants.PRIVACY_URL,
                                        textColor: AppColors.blue,
                                        underline: false),
                                  ),
                                  RichText(
                                    text: myUrl('Terms', Constants.TERMS_URL,
                                        textColor: AppColors.blue,
                                        underline: false),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  @override
  PaymentPageViewModel viewModelBuilder(BuildContext context) {
    return PaymentPageViewModel(
      context: context,
      profileRepository: locator.get(),
      localViewModel: locator.get(),
      sharedPreferenceHelper: locator.get(),
      phoneNumber: phoneNumber,
      verifyModel: verifyModel,
    );
  }
}
