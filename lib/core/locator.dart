import 'package:get_it/get_it.dart';
import 'package:gunsayaci/core/services/ads/admob_service.dart';
import 'package:gunsayaci/core/services/database_service.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton<HomeProvider>(() => HomeProvider());
  locator.registerLazySingleton<DatabaseService>(() => DatabaseService());
  locator.registerLazySingleton<CreateProvider>(() => CreateProvider());
  locator.registerLazySingleton<SettingsProvider>(() => SettingsProvider());
  locator.registerLazySingleton<AdmobService>(() => AdmobService());
}