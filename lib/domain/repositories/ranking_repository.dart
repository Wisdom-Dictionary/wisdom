import 'package:wisdom/data/model/roadmap/ranking_model.dart';

abstract class RankingRepository {
  Future<void> getRankingGlobal();

  List<RankingModel> get rankingGlobalList;
}
