import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/pages/create_page.dart';
import 'package:gunsayaci/pages/home_page.dart';
import 'package:gunsayaci/pages/settings_page.dart';
import 'package:gunsayaci/services/functions/admob_service.dart';
import 'package:gunsayaci/services/functions/notification_helper.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';
import 'package:gunsayaci/services/providers/settings_provider.dart';
import 'package:gunsayaci/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MobileAds.instance.initialize();
  await NotificationHelper.initialize();
  await EasyLocalization.ensureInitialized();
  setupLocator();
  tz.initializeTimeZones();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => locator.get<HomeProvider>()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (context) => locator.get<SettingsProvider>()),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale("en"),
          Locale("tr"),
          Locale("ar"),
          Locale("az"),
          Locale("tr"),
          Locale("es"),
          Locale("fr"),
          Locale("hi"),
          Locale("ja"),
          Locale("ur"),
          Locale("pt"),
          Locale("ru"),
        ],
        path: "assets/translations",
        fallbackLocale: const Locale("en"),
        child: const Home(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool _isPaused = false;

  @override
  void initState() {
    //AdmobService.callAppOpenAd(hideLoadingWidget: true);
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
      AdmobService.callAppOpenAd();
      _isPaused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) => !value.settingsFetch
          ? const SizedBox()
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: value.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                useMaterial3: true,
                brightness:
                    value.isDarkMode ? Brightness.dark : Brightness.light,
                fontFamily: "Poppins",
                scaffoldBackgroundColor: KColors.baseColor,
                textTheme: TextTheme(
                    bodyLarge: TextStyle(
                        color: value.isDarkMode ? null : Colors.black87)),
                appBarTheme: AppBarTheme(
                  color: KColors.baseColor,
                  titleTextStyle: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: value.isDarkMode ? null : Colors.black87),
                ),
              ),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              builder: EasyLoading.init(),
              initialRoute: "/",
              routes: {
                "/": (context) => const HomePage(),
                "/create": (context) => const CreatePage(),
                "/settings": (context) => const SettingsPage()
              },
            ),
    );
  }
}
