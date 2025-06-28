import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/core/di/app_locator.dart';
import 'package:wisdom/core/localization/locale_keys.g.dart';
import 'package:wisdom/data/model/contact_model.dart';
import 'package:wisdom/presentation/pages/adversitment/viewmodel/giving_ad_viewmodel.dart';

import '../../../config/constants/app_decoration.dart';
import '../../../config/constants/assets.dart';
import '../../../config/constants/constants.dart';
import '../../widgets/custom_app_bar.dart';

// ignore: must_be_immutable
class GivingAdPage extends ViewModelBuilderWidget<GivingAdViewModel> {
  GivingAdPage({super.key});

  @override
  void onViewModelReady(GivingAdViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.getAdContacts();
  }

  @override
  Widget builder(BuildContext context, GivingAdViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: CustomAppBar(
        title: LocaleKeys.contacts.tr(),
        onTap: () => Navigator.of(context).pop(),
        leadingIcon: Assets.icons.arrowLeft,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          viewModel.getAdContacts();
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: EdgeInsets.only(top: 30.h, left: 18.w, right: 18.w),
          child: SizedBox(
            width: double.infinity,
            height: 1.sh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isDarkTheme ? Assets.icons.logoWhiteText : Assets.icons.logoBlueText,
                  height: 52.h,
                  fit: BoxFit.scaleDown,
                ),
                viewModel.isSuccess(tag: 'getAdContactsTag')
                    ? _buildSupportContactsBody(viewModel)
                    : const SizedBox(),
                viewModel.isSuccess(tag: 'getAdContactsTag')
                    ? _buildContactsBody(viewModel)
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactsBody(GivingAdViewModel viewModel) {
    final contacts = viewModel.adContacts;
    if (contacts.isEmpty) return const SizedBox();
    return ContactBodyContent(
      child: Column(
        children: [
          Text(
            'disc_local_ad'.tr(),
            style: AppTextStyle.font17W500Normal.copyWith(
              color: isDarkTheme ? AppColors.white : AppColors.blue,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          ...List.generate(
            contacts.length,
            (index) => ContactItemWidget(
              model: contacts[index],
              onTap: () async {
                await contacts[index].launch();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSupportContactsBody(GivingAdViewModel viewModel) {
    final contacts = viewModel.supportContacts;
    if (contacts.isEmpty) return const SizedBox();
    return ContactBodyContent(
      child: Column(
        children: [
          Text(
            LocaleKeys.contact_for_support.tr(),
            style: AppTextStyle.font17W500Normal.copyWith(
              color: isDarkTheme ? AppColors.white : AppColors.blue,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          ...List.generate(
            contacts.length,
            (index) => ContactItemWidget(
              model: contacts[index],
              onTap: () async {
                await contacts[index].launch();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  GivingAdViewModel viewModelBuilder(BuildContext context) {
    return GivingAdViewModel(
      context: context,
      netWorkChecker: locator.get(),
      profileRepository: locator.get(),
      preferenceHelper: locator.get(),
    );
  }
}

class ContactBodyContent extends StatelessWidget {
  final Widget child;

  const ContactBodyContent({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h),
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 20.w),
      decoration: isDarkTheme ? AppDecoration.bannerDarkDecor : AppDecoration.bannerDecor,
      child: child,
    );
  }
}

class ContactItemWidget extends StatelessWidget {
  final ContactModel model;
  final EdgeInsets padding;
  final Function? onTap;

  const ContactItemWidget({
    required this.model,
    this.padding = EdgeInsets.zero,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton.icon(
        icon: SvgPicture.network(
          model.iconUrl,
          height: 30,
          width: 30,
        ),
        onPressed: () {
          onTap?.call();
        },
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.typeName,
              style: AppTextStyle.font15W500Normal.copyWith(
                color: isDarkTheme ? AppColors.white : AppColors.blue,
              ),
            ),
            Text(
              model.label ?? '',
              style: AppTextStyle.font15W500Normal.copyWith(
                color: isDarkTheme ? AppColors.white : AppColors.blue,
                decoration: TextDecoration.underline,
              ),
            )
          ],
        ),
      ),
    );
  }
}
