import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_empty_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_page.dart';
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
                        child: ContactItemWidget(
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
