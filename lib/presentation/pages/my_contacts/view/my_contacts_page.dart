import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/services/purchase_observer.dart';
import 'package:wisdom/data/model/my_contacts/user_details_model.dart';
import 'package:wisdom/presentation/components/w_button.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_app_bar.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_empty_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contcats_shimmer_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/you_have_not_premium_dialog.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/your_friend_have_not_premium_dialog.dart';
import 'package:wisdom/presentation/pages/my_contacts/viewmodel/my_contacts_viewmodel.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/searching_opponent_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class MyContactsPage extends StatefulWidget {
  const MyContactsPage({super.key});

  @override
  State<MyContactsPage> createState() => _MyContactsPageState();
}

class _MyContactsPageState extends State<MyContactsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final SearchingOpponentViewmodel searchingOpponentViewmodel;
  @override
  void initState() {
    searchingOpponentViewmodel = SearchingOpponentViewmodel(context: context);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Tab o'zgarganda UI yangilanadi
    });
    super.initState();
  }

  @override
  void dispose() {
    // searchingOpponentViewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: MyContactsAppBar(
        title: "my_contacts".tr(),
        actions: [
          Transform.translate(
            offset: Offset(0, 5),
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
              splashFactory: NoSplash.splashFactory,
              overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                // Use the default focused overlay color
                return states.contains(WidgetState.focused) ? null : Colors.transparent;
              }),
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
                      SvgPicture.asset(
                        Assets.icons.followed,
                        colorFilter: ColorFilter.mode(
                            _tabController.index == 1
                                ? AppColors.blue
                                : AppColors.white.withValues(alpha: 0.5),
                            BlendMode.srcIn),
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
        children: [
          ContactsList(
            searchingOpponentViewmodel: searchingOpponentViewmodel,
          ),
          ContactsFollowedList(
            searchingOpponentViewmodel: searchingOpponentViewmodel,
          )
        ],
      ),
    );
  }
}

class ContactsPermissionDialog extends StatelessWidget {
  const ContactsPermissionDialog({
    super.key,
  });

  String get getPermissionImage => switch (Theme.of(navigatorKey.currentContext!).platform) {
        TargetPlatform.android => Assets.images.contactPermissionAndroid,
        TargetPlatform.iOS => Assets.images.contactPermissionIos,
        _ => Assets.images.contactPermissionIos
      };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(18.0))),
      insetPadding: EdgeInsets.all(16),
      contentPadding: EdgeInsets.only(left: 24, top: 32, right: 24, bottom: 24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "contacts_access".tr(),
            style: AppTextStyle.font18W500Normal
                .copyWith(color: AppColors.blue, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Image.asset(getPermissionImage),
          ),
          Text(
            "contacts_access_content".tr(),
            textAlign: TextAlign.center,
            style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.black),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            children: [
              Expanded(
                child: WButton(
                  titleColor: AppColors.blue,
                  color: AppColors.lavender,
                  title: "cancel".tr(),
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: WButton(
                  title: "settings".tr(),
                  onTap: () async {
                    Navigator.pop(context, true);
                    await openAppSettings();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContactsList extends ViewModelBuilderWidget<MyContactsViewModel> {
  ContactsList({super.key, required this.searchingOpponentViewmodel});

  final SearchingOpponentViewmodel searchingOpponentViewmodel;

  @override
  void onViewModelReady(MyContactsViewModel viewModel) {
    viewModel.getMyContactUsers();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MyContactsViewModel viewModel, Widget? child) {
    return viewModel.isBusy(tag: viewModel.getMyContactsTag)
        ? const MyContcatsShimmerWidget()
        : viewModel.myContactsRepository.myContactsList.isEmpty || !viewModel.hasContactsPermission
            ? MyContactsEmptyPage(
                icon: SvgPicture.asset(Assets.icons.calendarOutlined),
                title: "title_my_contacts_list_empty".tr(),
                description: "description_my_contacts_list_empty".tr(),
              )
            : RefreshIndicator(
                onRefresh: () async => viewModel.getMyContactUsers(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 27),
                  itemCount: viewModel.myContactsRepository.myContactsList.length,
                  itemBuilder: (context, index) {
                    final item = viewModel.myContactsRepository.myContactsList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.contactDetailsPage,
                            arguments: item.toMap());
                      },
                      child: ContactItemWidget(
                        searchingOpponentViewmodel: searchingOpponentViewmodel,
                        item: item,
                      ),
                    );
                  },
                ),
              );
  }

  @override
  MyContactsViewModel viewModelBuilder(BuildContext context) {
    return MyContactsViewModel(context: context);
  }
}

class ContactsFollowedList extends ViewModelBuilderWidget<MyContactsViewModel> {
  ContactsFollowedList({super.key, required this.searchingOpponentViewmodel});
  final SearchingOpponentViewmodel searchingOpponentViewmodel;
  @override
  void onViewModelReady(MyContactsViewModel viewModel) {
    viewModel.getMyFollowedUsers();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, MyContactsViewModel viewModel, Widget? child) {
    return viewModel.isBusy(tag: viewModel.getMyContactsTag)
        ? const MyContcatsShimmerWidget()
        : viewModel.myContactsRepository.followedList.isEmpty
            ? MyContactsEmptyPage(
                icon: SvgPicture.asset(
                  height: 113,
                  width: 133,
                  Assets.icons.followed,
                  colorFilter:
                      ColorFilter.mode(AppColors.blue.withValues(alpha: 0.12), BlendMode.srcIn),
                ),
                title: "title_my_followed_list_empty".tr(),
                description: "description_my_followed_list_empty".tr(),
              )
            : RefreshIndicator(
                onRefresh: () async => viewModel.getMyFollowedUsers(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 27),
                  itemCount: viewModel.myContactsRepository.followedList.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.contactDetailsPage,
                          arguments: viewModel.myContactsRepository.followedList[index].toMap());
                    },
                    child: ContactItemWidget(
                      searchingOpponentViewmodel: searchingOpponentViewmodel,
                      item: viewModel.myContactsRepository.followedList[index],
                    ),
                  ),
                ),
              );
  }

  @override
  MyContactsViewModel viewModelBuilder(BuildContext context) {
    return MyContactsViewModel(context: context);
  }
}

class ContactItemWidget extends StatelessWidget {
  const ContactItemWidget(
      {super.key, required this.item, required this.searchingOpponentViewmodel});
  final UserDetailsModel item;
  final SearchingOpponentViewmodel searchingOpponentViewmodel;
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
            colorFilter: ColorFilter.mode(
                item.isOnlineStatus ? AppColors.green : AppColors.textDisabled, BlendMode.srcIn),
          ),
          const SizedBox(
            width: 4,
          ),
          InviteBattleWidget(
            userIsPremium: item.isPremuimStatus,
            userId: item.user!.id!,
            searchingOpponentViewmodel: searchingOpponentViewmodel,
          ),
        ],
      ),
    );
  }
}

class InviteBattleWidget extends StatelessWidget {
  InviteBattleWidget(
      {super.key,
      required this.userId,
      required this.userIsPremium,
      required this.searchingOpponentViewmodel});
  final int userId;
  final bool userIsPremium;
  final SearchingOpponentViewmodel searchingOpponentViewmodel;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: searchingOpponentViewmodel.inviteUpdateStatus,
      builder: (context, value, child) {
        return value &&
                userId == searchingOpponentViewmodel.invitedIserId &&
                !searchingOpponentViewmodel.isError(tag: searchingOpponentViewmodel.postInviteTag)
            ? const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    )),
              )
            : IconButton(
                visualDensity: VisualDensity(horizontal: -3, vertical: -4),
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (!PurchasesObserver().isPro()) {
                    showDialog(
                      context: context,
                      builder: (context) => YouHaveNotPremiumDialog(),
                    );
                  } else if (!userIsPremium) {
                    showDialog(
                      context: context,
                      builder: (context) => YourFriendHaveNotPremiumDialog(),
                    );
                  } else {
                    searchingOpponentViewmodel.postInviteBattle(opponentId: userId);
                  }
                },
                icon: SvgPicture.asset(
                  Assets.icons.battle,
                  colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                ),
              );
      },
    );
  }
}

// class InviteBattleWidget extends ViewModelBuilderWidget<SearchingOpponentViewmodel> {
//   InviteBattleWidget({super.key, required this.userId});
//   final int userId;
//   @override
//   void onViewModelReady(SearchingOpponentViewmodel viewModel) {
//     super.onViewModelReady(viewModel);
//   }

//   @override
//   Widget builder(BuildContext context, SearchingOpponentViewmodel viewModel, Widget? child) {
//     return viewModel.isBusy(tag: viewModel.postInviteTag)
//         ? SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(
//               strokeWidth: 2,
//             ))
//         : IconButton(
//             visualDensity: VisualDensity(horizontal: -3, vertical: -4),
//             padding: EdgeInsets.zero,
//             onPressed: () {
//               viewModel.postInviteBattle(opponentId: userId);
//             },
//             icon: SvgPicture.asset(
//               Assets.icons.battle,
//               colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
//             ),
//           );
//   }

//   @override
//   SearchingOpponentViewmodel viewModelBuilder(BuildContext context) {
//     return SearchingOpponentViewmodel(context: context);
//   }
// }
