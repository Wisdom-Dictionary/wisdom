import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/model/roadmap/word_answer_model.dart';

abstract class RoadmapRepository {
  Future<void> getLevels(int page);

  Future<void> getLevelWords();

  void setSelectedLevel(LevelWordModel item);

  Future<void> getTestQuestions();

  Future<void> getWordQuestions();

  Future<void> postWordQuestionsCheck(List<AnswerEntity> answers);

  List<LevelModel> get levelsList;

  int get userCurrentLevel;

  List<LevelWordModel> get levelWordsList;

  List<TestQuestionModel> get testQuestionsList;

  List<TestQuestionModel> get wordQuestionsList;

  List<WordAnswerModel> get wordQuestionsCheckList;

  int get levelExerciseId;

  String get startDate;

  String get endDate;

  int get totalQuestions;

  int get correctAnswers;

  bool get pass;
}
