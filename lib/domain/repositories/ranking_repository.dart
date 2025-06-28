import 'package:wisdom/data/model/roadmap/ranking_model.dart';

abstract class RankingRepository {
  Future<void> getRankingGlobal(int page);

  List<RankingModel> get rankingGlobalList;

  Future<void> getRankingContacts(int page);

  Future<void> getRankingContactsFromCache();

  List<RankingModel> get rankingContactList;

  bool get hasMoreGlobalRankingData;

  bool get hasMoreContactRankingData;

  int get userGlobalRanking;

  int get userCurrentGlobalLevel;

  int get userContactRanking;

  int get userCurrentContactLevel;
}
