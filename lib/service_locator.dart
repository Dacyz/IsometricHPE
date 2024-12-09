import 'package:app_position/features/providers/camera.dart';
import 'package:app_position/features/voice/presentation/voice_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

abstract class ServiceLocator {
  static void setup() {
    getIt.registerLazySingleton<VoiceRepository>(() => VoiceRepository());
    getIt.registerFactory<Camera>(() => Camera(getIt<VoiceRepository>()));
  }
}
