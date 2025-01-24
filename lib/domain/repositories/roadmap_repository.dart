import 'package:wisdom/data/model/roadmap/level_model.dart';

abstract class RoadmapRepository {
  Future<List<LevelModel>> getLevels();
}
