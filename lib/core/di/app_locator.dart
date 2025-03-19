import 'package:jbaza/jbaza.dart';
import 'package:wisdom/app.dart';
import 'package:wisdom/core/db/db_helper.dart';
import 'package:wisdom/core/db/preference_helper.dart';
import 'package:wisdom/core/services/ad/ad_service.dart';
import 'package:wisdom/core/services/ad/ad_service_factory.dart';
import 'package:wisdom/core/services/ad_state.dart';
import 'package:wisdom/core/services/custom_client.dart';
import 'package:wisdom/core/services/dio_client.dart';
import 'package:wisdom/core/services/notification_service.dart';
import 'package:wisdom/core/session/manager/session_manager.dart';
import 'package:wisdom/core/session/manager/session_manager_impl.dart';
import 'package:wisdom/core/utils/text_reader.dart';
import 'package:wisdom/core/utils/word_mapper.dart';
import 'package:wisdom/data/repositories/auth_repository_impl.dart';
import 'package:wisdom/data/repositories/battle_repository_impl.dart';
import 'package:wisdom/data/repositories/category_repository_impl.dart';
import 'package:wisdom/data/repositories/home_repository_impl.dart';
import 'package:wisdom/data/repositories/level_test_repository_impl.dart';
import 'package:wisdom/data/repositories/my_contacts_repository_impl.dart';
import 'package:wisdom/data/repositories/profile_repository_impl.dart';
import 'package:wisdom/data/repositories/ranking_repository_impl.dart';
import 'package:wisdom/data/repositories/roadmap_repository_impl.dart';
import 'package:wisdom/data/repositories/search_repository_impl.dart';
import 'package:wisdom/data/repositories/user_live_repository_impl.dart';
import 'package:wisdom/data/repositories/word_entity_repository_impl.dart';
import 'package:wisdom/data/repositories/wordbank_api_repository_impl.dart';
import 'package:wisdom/data/viewmodel/local_viewmodel.dart';
import 'package:wisdom/domain/repositories/auth_repository.dart';
import 'package:wisdom/domain/repositories/battle_repository.dart';
import 'package:wisdom/domain/repositories/category_repository.dart';
import 'package:wisdom/domain/repositories/home_repository.dart';
import 'package:wisdom/domain/repositories/level_test_repository.dart';
import 'package:wisdom/domain/repositories/my_contacts_repository.dart';
import 'package:wisdom/domain/repositories/profile_repository.dart';
import 'package:wisdom/domain/repositories/ranking_repository.dart';
import 'package:wisdom/domain/repositories/roadmap_repository.dart';
import 'package:wisdom/domain/repositories/search_repository.dart';
import 'package:wisdom/domain/repositories/user_live_repository.dart';
import 'package:wisdom/domain/repositories/word_entity_repository.dart';
import 'dart:developer';

import 'package:wisdom/domain/repositories/wordbank_api_repository.dart';
import 'package:wisdom/presentation/pages/roadmap_battle/viewmodel/battle_result_viewmodel.dart';

final locator = JbazaLocator.instance;

void setupLocator() {
  locator.registerSingleton<NetWorkChecker>(NetWorkChecker());
  locator.registerSingleton<WordMapper>(WordMapper());
  locator.registerSingletonAsync<TextReader>(() => TextReader.init());
  locator.registerSingleton<DBHelper>(DBHelper(locator.get()));
  locator.registerSingleton<AdState>(AdState());
  locator.registerSingleton<SharedPreferenceHelper>(SharedPreferenceHelper());
  locator.registerSingleton<SessionManager>(SessionManagerImpl(preferences: locator.get()));
  locator.registerSingleton<AppNotificationService>(AppNotificationService());
  locator.registerSingleton<DioClient>(DioClient(locator.get(), locator.get()));
  locator.registerSingleton<CustomClient>(CustomClient(sharedPreferenceHelper: locator.get()));
  locator.registerSingleton<LocalViewModel>(LocalViewModel(
      context: null, preferenceHelper: locator.get(), netWorkChecker: locator.get()));
  locator.registerLazySingleton<WordEntityRepository>(() => WordEntityRepositoryImpl(
      client: locator.get(), dbHelper: locator.get(), wordBankApiRepository: locator.get()));
  locator.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(locator.get(), locator.get(), locator.get()));
  locator.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(locator.get()));
  locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(locator.get(), locator.get()));
  locator.registerLazySingleton<WordBankApiRepository>(
      () => WordBankApiRepositoryImpl(dioClient: locator.get()));
  locator.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(locator.get(), locator.get()));
  locator.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(locator.get(), locator.get(), locator.get()));
  locator.registerSingletonAsync<AdService>(() async => AdServiceFactory.create());
  locator.registerLazySingleton<RoadmapRepository>(
      () => RoadmapRepositoryImpl(locator.get(), locator.get()));
  locator.registerLazySingleton<RankingRepository>(() => RankingRepositoryImpl(locator.get()));
  locator
      .registerLazySingleton<MyContactsRepository>(() => MyContactsRepositoryImpl(locator.get()));
  locator.registerLazySingleton<UserLiveRepository>(() => UserLiveRepositoryImpl(locator.get()));
  locator.registerLazySingleton<LevelTestRepository>(
      () => LevelTestRepositoryImpl(locator.get(), locator.get()));
  locator.registerLazySingleton<BattleRepository>(
      () => BattleRepositoryImpl(locator.get(), locator.get()));
}

Future resetLocator() async {
  log('reset locator');
  await locator.reset();
  setupLocator();
  await locator<AdState>().init();
  await locator<DBHelper>().init();
  await locator<SharedPreferenceHelper>().getInstance();
}
