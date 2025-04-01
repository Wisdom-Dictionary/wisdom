import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/rank_model.dart';

abstract class RoadmapRepository {
  Future<void> getLevels(int page);

  Future<void> getLevelWords();

  void setSelectedLevel(LevelModel item);

  List<LevelModel> get levelsList;

  int get userCurrentLevel;

  bool get canMoreLoad;

  RankModel? get userRank;

  List<LevelWordModel> get levelWordsList;
}
