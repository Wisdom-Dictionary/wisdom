import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_app_bar.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_empty_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contcats_shimmer_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/viewmodel/my_contacts_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class MyContactsPage extends StatefulWidget {
  const MyContactsPage({super.key});

  @override
  State<MyContactsPage> createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Tab o'zgarganda UI yangilanadi
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: MyContactsAppBar(
        title: "my_contacts".tr(),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.myContactsSearchPage);
                },
                icon: SvgPicture.asset(
                  Assets.icons.searchText,
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                )),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56.h),
          child: Container(
            height: 56.h,
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: AppColors.white.withValues(alpha: 0.1)),
            child: TabBar(
              indicatorColor: AppColors.red,
              dividerColor: Colors.transparent,
              indicator:
                  BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(23.5)),
              labelStyle:
                  AppTextStyle.font13W400Normal.copyWith(fontSize: 14, color: AppColors.blue),
              unselectedLabelStyle: AppTextStyle.font13W400Normal
                  .copyWith(fontSize: 14, color: AppColors.white.withValues(alpha: 0.5)),
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.note,
                        colorFilter: ColorFilter.mode(
                            _tabController.index == 0
                                ? AppColors.blue
                                : AppColors.white.withValues(alpha: 0.5),
                            BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Text("contacts_list".tr()))
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      Image.asset(
                        Assets.icons.check1,
                        color: _tabController.index == 1
                            ? AppColors.blue
                            : AppColors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Text("followed".tr()))
                    ],
                  ),
                )
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [ContactsList(), ContactsFollowedList()],
      ),
    );
  }
}

class ContactsList extends ViewModelBuilderWidget<MyContactsViewModel> {
  ContactsList({super.key});

  @override
  void onViewModelReady(MyContactsViewModel viewModel) {
    viewModel.getMyContacts(Contacts.getMyContacts);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MyContactsViewModel viewModel, Widget? child) {
    return viewModel.isBusy(tag: viewModel.getMyContactsTag)
        ? const MyContcatsShimmerWidget()
        : viewModel.isSuccess(tag: viewModel.getMyContactsTag)
            ? viewModel.myContactsRepository.contactsList.isEmpty
                ? MyContactsEmptyPage(
                    icon: SvgPicture.asset(Assets.icons.calendarOutlined),
                    title: "title_my_contacts_list_empty".tr(),
                    description: "description_my_contacts_list_empty".tr(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 27),
                    itemCount: 8,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.contactDetailsPage);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 13, bottom: 16, left: 18, right: 18),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.r),
                            color: AppColors.bgLightBlue.withValues(alpha: 0.1)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.icons.userAvatar,
                              height: 35,
                              width: 35,
                            ),
                            const SizedBox(
                              width: 11,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Farruh Saitov",
                                    style: AppTextStyle.font13W500Normal
                                        .copyWith(fontSize: 14, color: AppColors.blue),
                                  ),
                                  const SizedBox(
                                    height: 4.61,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "12460",
                                        style: AppTextStyle.font13W500Normal
                                            .copyWith(color: AppColors.blue),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      SvgPicture.asset(
                                        Assets.icons.verify,
                                        colorFilter:
                                            const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              Assets.icons.wifi,
                              colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            SvgPicture.asset(
                              Assets.icons.battle,
                              colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
            : const Center();
  }

  @override
  MyContactsViewModel viewModelBuilder(BuildContext context) {
    return MyContactsViewModel(context: context);
  }
}

class ContactsFollowedList extends ViewModelBuilderWidget<MyContactsViewModel> {
  ContactsFollowedList({super.key});

  @override
  void onViewModelReady(MyContactsViewModel viewModel) {
    viewModel.getMyContacts(Contacts.getMyContactsFollowed);
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MyContactsViewModel viewModel, Widget? child) {
    return viewModel.isBusy(tag: viewModel.getMyContactsTag)
        ? const MyContcatsShimmerWidget()
        : viewModel.isSuccess(tag: viewModel.getMyContactsTag)
            ? viewModel.myContactsRepository.contactsList.isEmpty
                ? MyContactsEmptyPage(
                    icon: Image.asset(
                      Assets.icons.check1Big,
                    ),
                    title: "title_my_followed_list_empty".tr(),
                    description: "description_my_followed_list_empty".tr(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 27),
                    itemCount: viewModel.myContactsRepository.contactsList.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.contactDetailsPage,
                            arguments: viewModel.myContactsRepository.contactsList[index].toMap());
                      },
                      child: ContactItemWidget(
                        item: viewModel.myContactsRepository.contactsList[index],
                      ),
                    ),
                  )
            : const Center();
  }

  @override
  MyContactsViewModel viewModelBuilder(BuildContext context) {
    return MyContactsViewModel(context: context);
  }
}

class ContactItemWidget extends StatelessWidget {
  const ContactItemWidget({super.key, required this.item});
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
            CircleAvatar(
              radius: 16.r,
              backgroundImage:
                  NetworkImage(Uri.encodeFull("${item.user!.profilePhotoUrl!}&format=png")),
              backgroundColor: Colors.transparent,
            ),
          const SizedBox(
            width: 11,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  item.user?.name ?? '',
                  style:
                      AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
                ),
                const SizedBox(
                  height: 4.61,
                ),
                Row(
                  children: [
                    Text(
                      item.user?.id.toString().padLeft(6, "0") ?? "",
                      style: AppTextStyle.font13W500Normal.copyWith(color: AppColors.blue),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    SvgPicture.asset(
                      Assets.icons.verify,
                      colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                    )
                  ],
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            Assets.icons.wifi,
            colorFilter: const ColorFilter.mode(AppColors.green, BlendMode.srcIn),
          ),
          const SizedBox(
            width: 24,
          ),
          SvgPicture.asset(
            Assets.icons.battle,
            colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
