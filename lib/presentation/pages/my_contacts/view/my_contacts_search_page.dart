import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_empty_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contcats_shimmer_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/viewmodel/my_contact_search_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';
import 'package:wisdom/presentation/widgets/new_custom_app_bar.dart';

class MyContactsSearchPage extends ViewModelBuilderWidget<MyContactSearchViewModel> {
  MyContactsSearchPage({super.key});

  @override
  void onViewModelReady(MyContactSearchViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MyContactSearchViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: NewCustomAppBar(
        onTap: () {
          Navigator.pop(context);
        },
        title: "Search contacts",
        isSearch: true,
        keyboardType: TextInputType.number,
        onChange: (text) {
          viewModel.searchMyContacts(text);
        },
      ),
      body: viewModel.isBusy(tag: viewModel.getMyContactSearchTag)
          ? const MyContcatsShimmerWidget()
          : viewModel.isSuccess(tag: viewModel.getMyContactSearchTag)
              ? viewModel.myContactsRepository.searchResultList.isEmpty
                  ? MyContactsEmptyPage(
                      icon: SvgPicture.asset(
                        height: 113,
                        width: 133,
                        Assets.icons.followed,
                        colorFilter: ColorFilter.mode(
                            AppColors.blue.withValues(alpha: 0.12), BlendMode.srcIn),
                      ),
                      title: "no_user_found".tr(),
                      description: "no_user_found_with_entered_id".tr(),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 27),
                      itemCount: viewModel.myContactsRepository.searchResultList.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.contactDetailsPage,
                              arguments:
                                  viewModel.myContactsRepository.searchResultList[index].toMap());
                        },
                        child: SearchUserItemWidget(
                          item: viewModel.myContactsRepository.searchResultList[index],
                        ),
                      ),
                    )
              : const Center(),
    );
  }

  @override
  MyContactSearchViewModel viewModelBuilder(BuildContext context) {
    return MyContactSearchViewModel(context: context);
  }
}

class SearchUserItemWidget extends StatelessWidget {
  const SearchUserItemWidget({
    super.key,
    required this.item,
  });
  final UserDetailsModel item;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 13, bottom: 16, left: 18, right: 18),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.r),
          color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
      child: Row(
        children: [
          if (item.user == null || item.user!.profilePhotoUrl == null)
            SvgPicture.asset(
              Assets.icons.userAvatar,
              height: 35,
              width: 35,
            )
          else
            Stack(
              children: [
                Container(
                  decoration: ShapeDecoration(
                      shape: CircleBorder(
                          side: BorderSide(
                              width: 2,
                              color: item.isPremuimStatus
                                  ? AppColors.yellow
                                  : AppColors.lightBackground))),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundImage:
                        NetworkImage(Uri.encodeFull("${item.user!.profilePhotoUrl!}&format=png")),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                if (item.isPremuimStatus)
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(1.6, -1.6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 3.2),
                          decoration:
                              const ShapeDecoration(color: AppColors.yellow, shape: CircleBorder()),
                          child: SvgPicture.asset(
                            Assets.icons.union,
                            width: 7.91,
                            height: 6.56,
                          ),
                        ),
                      ))
              ],
            ),
          const SizedBox(
            width: 11,
          ),
          Expanded(
            child: Text(
              item.user?.name ?? '',
              style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: ShapeDecoration(shape: StadiumBorder(), color: AppColors.blue),
            child: Row(
              children: [
                Text(
                  (item.userCurrentLevel ?? 0).toString(),
                  style: AppTextStyle.font13W500Normal
                      .copyWith(fontSize: 10, color: AppColors.bgAccent),
                ),
                SizedBox(
                  width: 4,
                ),
                SvgPicture.asset(
                  Assets.icons.verify,
                  width: 16,
                  height: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
