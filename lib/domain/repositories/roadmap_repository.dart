import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';

abstract class RoadmapRepository {
  Future<void> getLevels(int page);

  Future<void> getLevelWords();

  Future<void> getTestQuestions();

  List<LevelModel> get levelsList;

  int get userCurrentLevel;

  List<LevelWordModel> get levelWordsList;

  List<TestQuestionModel> get testQuestionsList;
}
