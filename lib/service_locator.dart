import 'package:app_position/features/database/presentation/database_repository.dart';
import 'package:app_position/features/routine/presentation/routine_repository.dart';
import 'package:app_position/features/voice/presentation/voice_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

abstract class ServiceLocator {
  static void setup() {
    getIt.registerLazySingleton<HiveRepository>(() => HiveRepository());
    getIt.registerLazySingleton<VoiceRepository>(() => VoiceRepository());
    getIt.registerFactory<RoutineRepository>(() => RoutineRepository(getIt<VoiceRepository>(),getIt<HiveRepository>()));
  }
}
