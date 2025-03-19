import 'package:wisdom/data/model/roadmap/ranking_model.dart';

abstract class RankingRepository {
  Future<void> getRankingGlobal(int page);

  List<RankingModel> get rankingGlobalList;

  bool get hasMoreData;

  int get userRanking;

  int get userCurrentLevel;
}
