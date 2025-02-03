import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';
import 'package:wisdom/data/model/roadmap/word_answer_model.dart';

abstract class LevelTestRepository {
  void setSelectedLevel(LevelModel item);

  void setExerciseType(TestExerciseType type);

  void setSelectedLevelMord(LevelWordModel item);

  Future<void> getTestQuestions();

  Future<void> postTestQuestionsCheck(List<AnswerEntity> answers, int timeTaken);

  Future<void> getWordQuestions();

  Future<void> postWordQuestionsCheck(List<AnswerEntity> answers);

  List<TestQuestionModel> get testQuestionsList;

  List<WordAnswerModel> get wordQuestionsCheckList;

  int get levelExerciseId;

  String get startDate;

  String get endDate;

  int get totalQuestions;

  int get correctAnswers;

  bool get pass;

  TestExerciseType get exerciseType;
}
