import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jbaza/jbaza.dart';
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
                      icon: Image.asset(
                        Assets.icons.check1Big,
                      ),
                      title: "User not found".tr(),
                      description: "Kiritilgan ID bo'yicha user topilmadi".tr(),
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
