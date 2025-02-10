import 'package:wisdom/data/model/roadmap/user_life_entity.dart';

abstract class UserLiveRepository {
  Future<void> getLives();

  Future<void> claimLives();

  UserLifeModel? get userLifesModel;
}
