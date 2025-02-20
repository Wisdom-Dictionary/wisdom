import 'package:wisdom/core/domain/entities/def_enum.dart';
import 'package:wisdom/data/model/roadmap/answer_entity.dart';
import 'package:wisdom/data/model/roadmap/level_model.dart';
import 'package:wisdom/data/model/roadmap/level_word_model.dart';
import 'package:wisdom/data/model/roadmap/test_answer_response_model.dart';
import 'package:wisdom/data/model/roadmap/test_question_model.dart';

abstract class LevelTestRepository {
  void setSelectedLevel(LevelModel item);

  void setExerciseType(TestExerciseType type);

  void setSelectedLevelMord(LevelWordModel item);

  Future<void> getTestQuestions();

  Future<void> postTestQuestionsCheck(List<AnswerEntity> answers, int timeTaken);

  Future<void> postTestQuestionsResult();

  Future<void> getWordQuestions();

  Future<void> postWordQuestionsCheck(List<AnswerEntity> answers);

  Future<void> postWordQuestionsResult();

  List<TestQuestionModel> get testQuestionsList;

  List<TestQuestionModel> get testQuestionsResultList;

  LevelExerciseResultModel? get resultModel;

  int get levelExerciseId;

  String get startDate;

  String get endDate;

  int get totalQuestions;

  int get correctAnswers;

  bool get pass;

  TestExerciseType get exerciseType;
}
