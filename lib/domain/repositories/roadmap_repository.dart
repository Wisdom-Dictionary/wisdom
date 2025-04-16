import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';

abstract class RoadmapRepository {
  Future<void> getLevels();

  Future<void> getLevelsPaginationBottom();

  Future<void> getLevelsPaginationTop();

  Future<void> getLevelWords();

  void setSelectedLevel(LevelModel item);

  List<LevelModel> get levelsList;

  int get userCurrentLevel;

  int get topLastPage;
  int get bottomLastPage;

  bool get canMoreLoad;

  bool get canMoreLoadBottom;
  bool get canMoreLoadTop;

  RankModel? get userRank;

  List<LevelWordModel> get levelWordsList;
}
