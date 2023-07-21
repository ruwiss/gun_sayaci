import 'package:get_it/get_it.dart';
import 'package:gunsayaci/services/backend/database_service.dart';
import 'package:gunsayaci/services/providers/settings_provider.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<DatabaseService>(DatabaseService());
  locator.registerSingleton<HomeProvider>(HomeProvider());
  locator.registerSingleton<SettingsProvider>(SettingsProvider());
}
