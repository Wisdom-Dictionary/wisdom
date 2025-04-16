import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/core/services/contacts_service.dart';
import 'package:wisdom/data/model/roadmap/ranking_model.dart';
import 'package:wisdom/presentation/components/shimmer.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_app_bar.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_empty_widget.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_page.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/life_status_bar.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/ranking_viewmodel.dart';

class ResultsSectionPage extends ViewModelBuilderWidget<RankingViewModel> {
  ResultsSectionPage({super.key});

  @override
  void onViewModelReady(RankingViewModel viewModel) {
    viewModel.getRankingGlobal();
    super.onViewModelReady(viewModel);
  }

  @override
  Widget builder(BuildContext context, RankingViewModel viewModel, Widget? child) {
    return ResultsSectionContentPage(
      viewModel: viewModel,
    );
  }

  @override
  RankingViewModel viewModelBuilder(BuildContext context) {
    return RankingViewModel(context: context);
  }
}

class ResultsSectionContentPage extends StatefulWidget {
  const ResultsSectionContentPage({super.key, required this.viewModel});
  final RankingViewModel viewModel;
  @override
  State<ResultsSectionContentPage> createState() => _ResultsSectionContentPageState();
}

class _ResultsSectionContentPageState extends State<ResultsSectionContentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Tab o'zgarganda UI yangilanadi
    });
    CustomContactService.requestContactPermission(context).then(
      (value) {
        if (!value) {
          showDialog(
            context: context,
            builder: (context) => ContactsPermissionDialog(),
          );
        } else {
          widget.viewModel.getRankingContact();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: MyContactsAppBar(
        title: "exercise_results".tr(),
        actions: const [
          LifeStatusBarPadding(child: LifeStatusBar()),
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
              overlayColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                // Use the default focused overlay color
                return states.contains(WidgetState.focused) ? null : Colors.transparent;
              }),
              splashFactory: NoSplash.splashFactory,
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
                        Assets.icons.contacts,
                        colorFilter: ColorFilter.mode(
                            _tabController.index == 0
                                ? AppColors.blue
                                : AppColors.white.withValues(alpha: 0.5),
                            BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Text("contacts".tr()))
                    ],
                  ),
                ),
                Tab(
                  icon: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.global,
                        colorFilter: ColorFilter.mode(
                            _tabController.index == 1
                                ? AppColors.blue
                                : AppColors.white.withValues(alpha: 0.5),
                            BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Text("global".tr()))
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
          ExercisesResultContactsPage(
            viewModel: widget.viewModel,
          ),
          ExercisesResultGlobalPage(
            viewModel: widget.viewModel,
          )
        ],
      ),
    );
  }
}

class ShimmerExercisesResult extends StatelessWidget {
  const ShimmerExercisesResult({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 12),
        itemCount: 4,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: ShapeDecoration(
            color: AppColors.blue.withValues(alpha: 0.3),
            shape: StadiumBorder(),
          ),
          child: Row(
            children: [
              Text(
                "${index + 1}",
                style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
              ),
              const SizedBox(
                width: 8,
              ),
              Image.asset(Assets.images.goldMedal),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 27,
                  width: 130,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(), color: AppColors.blue.withValues(alpha: 0.4)),
                ),
              )),
              Container(
                width: 77,
                height: 24,
                decoration: ShapeDecoration(
                    shape: StadiumBorder(), color: AppColors.blue.withValues(alpha: 0.4)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExercisesResultContactsPage extends StatefulWidget {
  const ExercisesResultContactsPage({super.key, required this.viewModel});
  final RankingViewModel viewModel;

  @override
  State<ExercisesResultContactsPage> createState() => _ExercisesResultContactsPageState();
}

class _ExercisesResultContactsPageState extends State<ExercisesResultContactsPage> {
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);

    super.initState();
  }

  late ScrollController _scrollController;

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!widget.viewModel.isBusy(tag: widget.viewModel.getRankingContactMoreTag)) {
        widget.viewModel.getRankingContactMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.viewModel.hasContactsPermission ||
            widget.viewModel.roadMapRepository.rankingContactList.isEmpty
        ? MyContactsEmptyPage(
            icon: SvgPicture.asset(Assets.icons.calendarOutlined),
            title: "title_my_contacts_list_empty".tr(),
            description: "description_my_contacts_list_empty".tr(),
          )
        : widget.viewModel.isBusy(tag: widget.viewModel.getRankingContactTag)
            ? ShimmerExercisesResult()
            : widget.viewModel.isSuccess(tag: widget.viewModel.getRankingContactTag)
                ? Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async => widget.viewModel.getRankingContact(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 12, bottom: 100),
                          itemCount: widget.viewModel.roadMapRepository.rankingContactList.length +
                              (widget.viewModel
                                      .isBusy(tag: widget.viewModel.getRankingContactMoreTag)
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                widget.viewModel.roadMapRepository.rankingContactList.length) {
                              return Stack(
                                children: [
                                  RankingItemWidget(
                                    index: index,
                                    item: widget
                                        .viewModel.roadMapRepository.rankingContactList[index],
                                  ),
                                  if (widget.viewModel.selectedItem != null &&
                                      widget.viewModel.selectedItem!.userId ==
                                          widget.viewModel.roadMapRepository
                                              .rankingContactList[index].userId)
                                    Positioned.fill(
                                        child: ShimmerWidget(
                                            child: Container(
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: const ShapeDecoration(
                                          color: AppColors.black, shape: StadiumBorder()),
                                    )))
                                ],
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SafeArea(
                            child: CurrentUserItemWidget(
                                index: widget.viewModel.roadMapRepository.userContactRanking,
                                item: RankingModel(
                                    name: "you".tr(),
                                    level: widget
                                        .viewModel.roadMapRepository.userCurrentContactLevel)),
                          ))
                    ],
                  )
                : const Center(child: Text("Unhandled Exception"));
  }
}

class ExercisesResultGlobalPage extends StatefulWidget {
  const ExercisesResultGlobalPage({super.key, required this.viewModel});
  final RankingViewModel viewModel;

  @override
  State<ExercisesResultGlobalPage> createState() => _ExercisesResultGlobalPageState();
}

class _ExercisesResultGlobalPageState extends State<ExercisesResultGlobalPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!widget.viewModel.isBusy(tag: widget.viewModel.getRankingGlobalMoreTag)) {
        widget.viewModel.getRankingGlobalMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.viewModel.isBusy(tag: widget.viewModel.getRankingGlobalTag)
        ? ShimmerExercisesResult()
        : widget.viewModel.roadMapRepository.rankingGlobalList.isEmpty
            ? MyContactsEmptyPage(
                icon: SvgPicture.asset(
                  height: 113,
                  width: 133,
                  Assets.icons.followed,
                  colorFilter:
                      ColorFilter.mode(AppColors.blue.withValues(alpha: 0.12), BlendMode.srcIn),
                ),
                title: "no_data".tr(),
                description: "",
              )
            : widget.viewModel.isSuccess(tag: widget.viewModel.getRankingGlobalTag)
                ? Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async => widget.viewModel.getRankingGlobal(),
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 12, bottom: 100),
                          itemCount: widget.viewModel.roadMapRepository.rankingGlobalList.length +
                              (widget.viewModel
                                      .isBusy(tag: widget.viewModel.getRankingGlobalMoreTag)
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index <
                                widget.viewModel.roadMapRepository.rankingGlobalList.length) {
                              return GestureDetector(
                                onTap: () {
                                  if (!widget.viewModel
                                      .isBusy(tag: widget.viewModel.getUserDetailsByIdTag)) {
                                    widget.viewModel.getUserDetails(widget
                                        .viewModel.roadMapRepository.rankingGlobalList[index]);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    RankingItemWidget(
                                      index: index,
                                      item: widget
                                          .viewModel.roadMapRepository.rankingGlobalList[index],
                                    ),
                                    if (widget.viewModel.selectedItem != null &&
                                        widget.viewModel.selectedItem!.userId ==
                                            widget.viewModel.roadMapRepository
                                                .rankingGlobalList[index].userId)
                                      Positioned.fill(
                                          child: ShimmerWidget(
                                              child: Container(
                                        margin:
                                            const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        decoration: const ShapeDecoration(
                                            color: AppColors.black, shape: StadiumBorder()),
                                      )))
                                  ],
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: SafeArea(
                            child: CurrentUserItemWidget(
                                index: widget.viewModel.roadMapRepository.userGlobalRanking,
                                item: RankingModel(
                                    name: "you".tr(),
                                    level:
                                        widget.viewModel.roadMapRepository.userCurrentGlobalLevel)),
                          ))
                    ],
                  )
                : const Center(child: Text("Unhandled Exception"));
  }
}

class RankingItemWidget extends StatelessWidget {
  const RankingItemWidget({super.key, required this.index, required this.item});
  final int index;
  final RankingModel item;
  static const int topRatingCount = 3;

  bool get itemInTopRating {
    return index + 1 <= topRatingCount;
  }

  Color? get itemBackgroundColor {
    if (item.you ?? false) {
      return AppColors.blanchedAlmond;
    }
    if (itemInTopRating) {
      return AppColors.bgLightBlue.withValues(alpha: 0.1);
    }
  }

  BorderSide get itemBorder {
    if (item.you ?? false) {
      return const BorderSide(width: 2, color: AppColors.bgAccent);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration:
          ShapeDecoration(shape: StadiumBorder(side: itemBorder), color: itemBackgroundColor),
      child: Row(
        children: [
          indexText(),
          const SizedBox(
            width: 8,
          ),
          if (itemInTopRating)
            Row(
              children: [
                Image.network(
                  height: 32,
                  width: 32,
                  item.rankIconUrl,
                  errorBuilder: (context, error, stackTrace) => Center(),
                ),
              ],
            ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            item.name ?? "",
            style: AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.darkGray),
          )),
          if (item.level != null) itemLevel(item.level)
        ],
      ),
    );
  }

  Widget itemLevel(int? level) {
    if (itemInTopRating) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: ShapeDecoration(shape: StadiumBorder(), color: AppColors.blue),
        child: Row(
          children: [
            Text(
              level.toString(),
              style:
                  AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.bgAccent),
            ),
            SizedBox(
              width: 4,
            ),
            SvgPicture.asset(
              Assets.icons.verify,
              width: 12,
              height: 12,
            )
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Text(
            level.toString(),
            style: AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
          ),
          SizedBox(
            width: 4,
          ),
          SvgPicture.asset(
            Assets.icons.verify,
            width: 12,
            height: 12,
            colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
          )
        ],
      ),
    );
  }

  Text indexText() {
    if (itemInTopRating) {
      return Text(
        "${index + 1}.",
        style: AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.vibrantBlue),
      );
    }
    return Text(
      item.ranking.toString(),
      style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
    );
  }
}

class CurrentUserItemWidget extends StatelessWidget {
  const CurrentUserItemWidget({super.key, required this.index, required this.item});
  final int index;
  final RankingModel item;
  static const int topRatingCount = 3;

  bool get itemInTopRating {
    return index + 1 <= topRatingCount;
  }

  Color? get itemBackgroundColor {
    return AppColors.blue;
  }

  BorderSide get itemBorder {
    if (item.you ?? false) {
      return const BorderSide(width: 2, color: AppColors.bgAccent);
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15.5),
      decoration:
          ShapeDecoration(shape: StadiumBorder(side: itemBorder), color: itemBackgroundColor),
      child: Row(
        children: [
          indexText(),
          const SizedBox(
            width: 8,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            item.name ?? "",
            style: AppTextStyle.font15W600Normal.copyWith(fontSize: 14, color: AppColors.white),
          )),
          if (item.level != null) itemLevel(item.level)
        ],
      ),
    );
  }

  Widget itemLevel(int? level) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(shape: StadiumBorder(), color: AppColors.yellow),
      child: Row(
        children: [
          Text(
            level.toString(),
            style: AppTextStyle.font13W500Normal.copyWith(fontSize: 10, color: AppColors.blue),
          ),
          SizedBox(
            width: 4,
          ),
          SvgPicture.asset(
            width: 12,
            height: 12,
            Assets.icons.verify,
            colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
          )
        ],
      ),
    );
  }

  Text indexText() {
    return Text(
      "$index",
      style: AppTextStyle.font15W600Normal
          .copyWith(fontSize: 14, color: AppColors.white.withValues(alpha: 0.3)),
    );
  }
}
