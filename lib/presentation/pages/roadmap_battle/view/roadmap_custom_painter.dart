import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:wisdom/config/constants/app_colors.dart';
import 'package:wisdom/config/constants/assets.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/roadmap_shimmer_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/view/widgets/task_level_indicator_widget.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/life_countdown_provider.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/roadmap_viewmodel.dart';
import 'package:wisdom/presentation/routes/routes.dart';

class ExampleRoadMap extends StatefulWidget {
  const ExampleRoadMap({super.key, required this.viewModel});

  final RoadMapViewModel viewModel;
  @override
  State<ExampleRoadMap> createState() => _ExampleRoadMapState();
}

class _ExampleRoadMapState extends State<ExampleRoadMap> {
  Container backgroundGradient(LinearGradient gradient) {
    return Container(
      height: 137,
      decoration: BoxDecoration(gradient: gradient),
    );
  }

  LinearGradient topGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0xFFE2F2F8),
          Color(0x00F0F8FB),
        ]);
  }

  LinearGradient bottomGradient() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        tileMode: TileMode.clamp,
        colors: [
          Color(0x00F0F8FB),
          Color(0xFFE2F2F8),
        ]);
  }

  static const iconSize = 100.0;
  static const pathCornerRad = 80.0;

  List<Map<String, dynamic>> generatePositions(int count) {
    final List<Map<String, dynamic>> basePositions = [
      {"left": null, "right": 83, "bottom": 1},
      {"left": 82, "right": null, "bottom": 1.05},
      {"left": 20, "right": null, "bottom": 1.7},
      {"left": null, "right": 126, "bottom": 2},
      {"left": null, "right": 14, "bottom": 2.8},
      {"left": 120, "right": null, "bottom": 3},
      {"left": 10, "right": null, "bottom": 3.5},
      {"left": 100, "right": null, "bottom": 4},
      {"left": null, "right": 14, "bottom": 4.2},
      {"left": null, "right": 50, "bottom": 5},
      {"left": 82, "right": null, "bottom": 5.1},
      {"left": 20, "right": null, "bottom": 5.8},
      {"left": null, "right": 100, "bottom": 6},
      {"left": null, "right": 14, "bottom": 6.6},
      {"left": 120, "right": null, "bottom": 7},
      {"left": 14, "right": null, "bottom": 7.5},
      {"left": 150, "right": null, "bottom": 8},
    ];

    //   final List<Map<String, dynamic>> basePositions = [
    //   {"left": null, "right": 83, "bottom": 1},
    //   {"left": 82, "right": null, "bottom": 1.05},
    //   {"left": 20, "right": null, "bottom": 1.7},
    //   {"left": null, "right": 126, "bottom": 2},
    //   {"left": null, "right": 24, "bottom": 2.8},
    //   {"left": 120, "right": null, "bottom": 3},
    //   {"left": 10, "right": null, "bottom": 3.5},
    //   {"left": 100, "right": null, "bottom": 4},
    //   {"left": null, "right": 64, "bottom": 4.05},
    //   {"left": null, "right": 50, "bottom": 5},
    //   {"left": 82, "right": null, "bottom": 5.1},
    //   {"left": 20, "right": null, "bottom": 5.8},
    //   {"left": null, "right": 100, "bottom": 6},
    //   {"left": null, "right": 14, "bottom": 6.6},
    //   {"left": 120, "right": null, "bottom": 7},
    //   {"left": 14, "right": null, "bottom": 7.5},
    //   {"left": 150, "right": null, "bottom": 8},
    // ];

    final List<Map<String, dynamic>> result = [];

    final double bottomStart = (basePositions.first['bottom'] as num).toDouble();
    final double bottomEnd = (basePositions.last['bottom'] as num).toDouble();

    // Real shift — har bir loop'da necha "bottom" birlik bilan suriladi
    final double bottomShift = bottomEnd - bottomStart + 1;

    for (int i = 0; i < count; i++) {
      final pattern = basePositions[i % basePositions.length];
      final int loop = i ~/ basePositions.length;

      final double newBottom = (pattern['bottom'] as num).toDouble() + (loop * bottomShift);

      result.add({
        'left': pattern['left'],
        'right': pattern['right'],
        'bottom': newBottom,
      });
    }

    return result;
  }

  List<Positioned> levelItems(RoadmapRepository repository) {
    List positions = generatePositions(repository.levelsList.length);

    List<Positioned> items = List.generate(repository.levelsList.length, (index) {
      int positionIndex = index;
      if (index >= positions.length) {
        positionIndex = positions.length - 1;
      }

      double? left = (positions[positionIndex]["left"] as int?)?.toDouble();
      double? right = (positions[positionIndex]["right"] as int?)?.toDouble();
      double? bottom = ((positions[positionIndex]["bottom"] ?? 1) * pathCornerRad * 2).toDouble();
      bool activeLevel = repository.levelsList[index].userCurrentLevel ?? false;

      return Positioned(
          left: left,
          right: right,
          bottom: activeLevel && bottom != null ? bottom - 80 : (bottom! - 50),
          child: GestureDetector(
              onTap: () => widget.viewModel.selectLevel(repository.levelsList[index]),
              child: repository.levelsList[index].itemWidget));
    });

    if (widget.viewModel.isBusy(tag: widget.viewModel.getLevelsMoreTag)) {
      Map<String, dynamic> loadingWidgetposition = generatePositions(positions.length + 1).last;

      double? left = (loadingWidgetposition["left"] as int?)?.toDouble();
      double? right = (loadingWidgetposition["right"] as int?)?.toDouble();
      double? bottom = ((loadingWidgetposition["bottom"] ?? 1) * pathCornerRad * 2).toDouble();

      final loadingWidget = Positioned(
        left: left,
        right: right,
        bottom: (bottom! - 50),
        child: Stack(
          children: [
            LevelItem(
              item: LevelModel(name: "0"),
            ),
            const Positioned.fill(child: Center(child: CupertinoActivityIndicator()))
          ],
        ),
      );

      items.add(loadingWidget);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.watch<CountdownProvider>().status,
      builder: (context, status, child) {
        if (status == FormzSubmissionStatus.inProgress) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.images.roadmapBattleBackground1,
                  fit: BoxFit.fitWidth,
                ),
              ),
              buildLoadingState(),
            ],
          );
        }

        return Stack(
          children: [
            if (widget.viewModel.isSuccess(tag: widget.viewModel.getLevelsTag) ||
                (widget.viewModel.isBusy(tag: widget.viewModel.getLevelsMoreTag) &&
                    widget.viewModel.page > 1))
              buildSuccessState()
            else
              Positioned.fill(
                child: Image.asset(
                  Assets.images.roadmapBattleBackground1,
                  fit: BoxFit.fitWidth,
                ),
              ),
            if (widget.viewModel.isBusy(tag: widget.viewModel.getLevelsTag)) buildLoadingState(),
            buildTopRightButton(context),
          ],
        );
      },
    );
  }

  Widget buildLoadingState() {
    return const RoadmapShimmerWidget();
  }

  final ScrollController _scrollController = ScrollController();
  final double itemHeight = 100; // Har bir item balandligi (taxminan)
  final int visibleItemCount = 9; // Ekranda ko‘rinadigan itemlar soni

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final enableToPagination = _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent -
              (widget.viewModel.roadMapRepository.levelsList.length * 4);

      bool canMoreLoadTop = widget.viewModel.roadMapRepository.canMoreLoadTop;
      if (canMoreLoadTop &&
          enableToPagination &&
          !widget.viewModel.isBusy(tag: widget.viewModel.getLevelsMoreTag)) {
        widget.viewModel.getLevelsTopMore();
      }

      final enableToPaginationBottom =
          _scrollController.position.pixels <= _scrollController.position.minScrollExtent &&
              !widget.viewModel.isBusy(tag: widget.viewModel.getLevelsMoreTag);
      bool canMoreLoadBottom = widget.viewModel.roadMapRepository.canMoreLoadBottom;

      if (enableToPaginationBottom && canMoreLoadBottom) {
        widget.viewModel.getLevelsBottomMore();
      }
    });
  }

  Widget buildSuccessState() {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        reverse: true,
        child: SafeArea(
          child: Stack(
            children: [
              buildBackgroundLayer(),
              buildPathLayers(),
              buildLevelItemsLayer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBackgroundLayer() {
    final List<String> imageList = [
      Assets.images.roadmapBattleBackground1,
      Assets.images.roadmapBattleBackground2,
      Assets.images.roadmapBattleBackground3,
      Assets.images.roadmapBattleBackground4,
      Assets.images.roadmapBattleBackground5,
      Assets.images.roadmapBattleBackground6,
      Assets.images.roadmapBattleBackground7,
      Assets.images.roadmapBattleBackground8,
    ];

    final double imageHeight = MediaQuery.of(context).size.height;
    int levelsLength =
        widget.viewModel.roadMapRepository.levelsList.length; // or custom height per scroll page
    final double heightSize =
        pathCornerRad * (levelsLength < 6 ? 6 : levelsLength); // dynamic value, example
    final int scrollPageCount = (heightSize / imageHeight).ceil(); // dynamic value, example

    return Positioned.fill(
      child: Stack(
        children: [
          ...List.generate(scrollPageCount, (index) {
            final imageIndex = index % 8; // 0 to 7 repeat
            final imagePath = imageList[imageIndex]; // imageList = your 8 images

            return Positioned(
              bottom: index * imageHeight, // each background image positioned higher
              left: 0,
              right: 0,
              height: imageHeight, // Adjust according to scrollable screen height
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildPathLayers() {
    final levelsLength = widget.viewModel.roadMapRepository.levelsList.length;

    return Stack(
      children: [
        CustomPaint(
          painter: DashedPathPainter(
            originalPath: (size) =>
                _customPathFromBottomToTop(size, pathCornerRad, iconSize, levelsLength)
                    .reversed
                    .toList(),
            pathColors: [],
            pathColor: AppColors.white,
            strokeWidth: 40,
            dashGapLength: 0.01,
            dashLength: 7.0,
          ),
          child: const Center(),
        ),
        CustomPaint(
          painter: DashedPathPainter(
            originalPath: (size) =>
                _customPathFromBottomToTop(size, pathCornerRad, iconSize, levelsLength),
            pathColors: [],
            pathColor: AppColors.blue,
            strokeWidth: 1,
            dashGapLength: 10.0,
            dashLength: 8.0,
          ),
          child: SizedBox(
            width: iconSize * 70,
            height: pathCornerRad * (levelsLength < 6 ? 6 : levelsLength),
            child: Stack(
              children: levelItems(widget.viewModel.roadMapRepository),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLevelItemsLayer() {
    // Bu metod alohida bo'lishi shart emas, lekin kerak bo'lsa tozalab ajratib qo'yiladi.
    return const SizedBox
        .shrink(); // Agar yuqoridagi CustomPaint ichida ishlatilsa, bu optional bo'ladi
  }

  Widget buildTopRightButton(BuildContext context) {
    return Positioned(
      top: 90,
      right: 5,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.resultsSectionPage);
          },
          child: FlagIndicatorWidget(
            userLevel: widget.viewModel.roadMapRepository.userCurrentLevel,
          ),
        ),
      ),
    );
  }

  List<Path> _customPathFromBottomToTop(
    Size size,
    double cornerRadius,
    double iconSize,
    int iconCount,
  ) {
    final width = size.width;
    final List<Path> paths = [];

    // Ikki chet icon hisobga olinmaydi
    final usableIconCount = iconCount - 2;

    // Chiziqlar soni (yani, path lar soni)
    final pathCount = (usableIconCount / 2).ceil();

    // === 1. Birinchi (eng pastki) path chiziladi ===
    final firstPath = Path();
    final firstStartX = iconSize / 2;
    final firstStartY = ((pathCount - 1) * cornerRadius * 2) + iconSize;

    firstPath.moveTo(firstStartX, firstStartY);
    firstPath
      ..arcToPoint(
        Offset(firstStartX + cornerRadius, firstStartY + cornerRadius),
        clockwise: false,
        radius: Radius.circular(cornerRadius),
      )
      ..relativeLineTo(width - (cornerRadius * 2) - iconSize, 0)
      ..relativeArcToPoint(
        Offset(cornerRadius + iconSize / 2, 0),
        clockwise: true,
        radius: const Radius.circular(0),
      );

    paths.add(firstPath);

    // === 2. Qolgan path lar (zigzag) chiziladi ===
    for (int i = pathCount - 2; i >= 0; i--) {
      final path = Path();
      final currentStartY = (i * cornerRadius * 2) + iconSize;

      final isLeftToRight = (pathCount - 2).isEven ? i.isOdd : i.isEven; // Zigzag yo‘nalish

      if (isLeftToRight) {
        // Chapdan o‘ngga
        final currentStartX = iconSize / 2;
        path.moveTo(currentStartX, currentStartY);
        path
          ..arcToPoint(
            Offset(currentStartX + cornerRadius, currentStartY + cornerRadius),
            clockwise: false,
            radius: Radius.circular(cornerRadius),
          )
          ..relativeLineTo(width - (cornerRadius * 2) - iconSize, 0)
          ..relativeArcToPoint(
            Offset(cornerRadius, cornerRadius),
            clockwise: true,
            radius: Radius.circular(cornerRadius),
          );
      } else {
        // O‘ngdan chapga
        final currentStartX = width - iconSize / 2;
        path.moveTo(currentStartX, currentStartY);
        path
          ..arcToPoint(
            Offset(currentStartX - cornerRadius, currentStartY + cornerRadius),
            clockwise: true,
            radius: Radius.circular(cornerRadius),
          )
          ..relativeLineTo(-width + (cornerRadius * 2) + iconSize, 0)
          ..relativeArcToPoint(
            Offset(-cornerRadius, cornerRadius),
            clockwise: false,
            radius: Radius.circular(cornerRadius),
          );
      }

      paths.add(path);
    }

    return paths;
  }
}

class DashedPathPainter extends CustomPainter {
  final List<Path> Function(Size) originalPath;
  final List<Color> pathColors;
  final Color pathColor;
  final double strokeWidth;
  final double dashGapLength;
  final double dashLength;

  DashedPathPainter({
    required this.originalPath,
    required this.pathColors,
    required this.pathColor,
    this.strokeWidth = 3.0,
    this.dashGapLength = 5.0,
    this.dashLength = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paths = originalPath.call(size);

    for (int i = 0; i < paths.length; i++) {
      final dashedPath = _getDashedPath(
          DashedPathProperties(
            path: Path(),
            dashLength: dashLength,
            dashGapLength: dashGapLength,
          ),
          paths[i],
          dashLength,
          dashGapLength);

      Color color = pathColor;
      if (i < pathColors.length) {
        color = pathColors[i];
      }

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..color = color
        ..strokeWidth = strokeWidth;
      canvas.drawPath(dashedPath, paint);
    }
  }

  @override
  bool shouldRepaint(DashedPathPainter oldDelegate) =>
      oldDelegate.originalPath != originalPath ||
      oldDelegate.pathColor != pathColor ||
      oldDelegate.pathColors != pathColors ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashGapLength != dashGapLength ||
      oldDelegate.dashLength != dashLength;

  Path _getDashedPath(
    DashedPathProperties pathProps,
    Path originalPath,
    double dashLength,
    double dashGapLength,
  ) {
    final metricsIterator = originalPath.computeMetrics().iterator;
    while (metricsIterator.moveNext()) {
      final metric = metricsIterator.current;
      pathProps.extractedPathLength = 0.0;
      while (pathProps.extractedPathLength < metric.length) {
        if (pathProps.addDashNext) {
          pathProps.addDash(metric, dashLength);
        } else {
          pathProps.addDashGap(metric, dashGapLength);
        }
      }
    }
    return pathProps.path;
  }
}

class DashedPathProperties {
  double extractedPathLength;
  Path path;

  final double _dashLength;
  double _remainingDashLength;
  double _remainingDashGapLength;
  bool _previousWasDash;

  DashedPathProperties({
    required this.path,
    required double dashLength,
    required double dashGapLength,
  })  : assert(dashLength > 0.0, 'dashLength must be > 0.0'),
        assert(dashGapLength > 0.0, 'dashGapLength must be > 0.0'),
        _dashLength = dashLength,
        _remainingDashLength = dashLength,
        _remainingDashGapLength = dashGapLength,
        _previousWasDash = false,
        extractedPathLength = 0.0;

  bool get addDashNext {
    if (!_previousWasDash || _remainingDashLength != _dashLength) {
      return true;
    }
    return false;
  }

  void addDash(ui.PathMetric metric, double dashLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashLength);
    final availableEnd = _calculateLength(metric, dashLength);
    // Add path
    final pathSegment = metric.extractPath(extractedPathLength, end);
    path.addPath(pathSegment, Offset.zero);
    // Update
    final delta = _remainingDashLength - (end - extractedPathLength);
    _remainingDashLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashLength,
    );
    extractedPathLength = end;
    _previousWasDash = true;
  }

  void addDashGap(ui.PathMetric metric, double dashGapLength) {
    // Calculate lengths (actual + available)
    final end = _calculateLength(metric, _remainingDashGapLength);
    final availableEnd = _calculateLength(metric, dashGapLength);
    // Move path's end point
    ui.Tangent tangent = metric.getTangentForOffset(end)!;
    path.moveTo(tangent.position.dx, tangent.position.dy);
    // Update
    final delta = end - extractedPathLength;
    _remainingDashGapLength = _updateRemainingLength(
      delta: delta,
      end: end,
      availableEnd: availableEnd,
      initialLength: dashGapLength,
    );
    extractedPathLength = end;
    _previousWasDash = false;
  }

  double _calculateLength(ui.PathMetric metric, double addedLength) {
    return math.min(extractedPathLength + addedLength, metric.length);
  }

  double _updateRemainingLength({
    required double delta,
    required double end,
    required double availableEnd,
    required double initialLength,
  }) {
    return (delta > 0 && availableEnd == end) ? delta : initialLength;
  }
}
