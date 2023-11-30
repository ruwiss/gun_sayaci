import 'package:get_it/get_it.dart';
import 'package:gunsayaci/core/services/admob_service.dart';
import 'package:gunsayaci/core/services/database/countdown_service.dart';
import 'package:gunsayaci/core/services/database/settings_service.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton<HomeProvider>(() => HomeProvider());
  locator.registerLazySingleton<SettingsService>(() => SettingsService());
  locator.registerLazySingleton<CountdownService>(() => CountdownService());
  locator.registerLazySingleton<CreateProvider>(() => CreateProvider());
  locator.registerLazySingleton<SettingsProvider>(() => SettingsProvider());
  locator.registerLazySingleton<AdmobService>(() => AdmobService());
}
