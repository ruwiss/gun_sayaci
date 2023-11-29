import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/theme.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/core.dart';
import 'utils/strings.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MobileAds.instance.initialize();
  setupLocator();
  await NotificationHelper.initialize();
  await EasyLocalization.ensureInitialized();
  await locator<SettingsProvider>().init();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => locator<HomeProvider>(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (context) => locator<SettingsProvider>(),
        ),
      ],
      child: EasyLocalization(
        path: "assets/translations",
        fallbackLocale: const Locale("en"),
        supportedLocales:
            KStrings.supportedLocales.map((e) => Locale(e)).toList(),
        child: const Home(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool _isPaused = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _isPaused = true;
    }
    if (state == AppLifecycleState.resumed && _isPaused) {
      AdmobService.callAppOpenAd(onAction: () => Navigator.pop(context));
      _isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        themeMode: value.themeMode,
        theme: context.lightTheme(),
        darkTheme: context.darkTheme(),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routerConfig: router,
      ),
    );
  }
}
