import 'package:go_router/go_router.dart';
import 'package:gunsayaci/common/models/data_model.dart';
import 'package:gunsayaci/ui/views/create/create_page.dart';
import 'package:gunsayaci/ui/views/home/home_page.dart';
import 'package:gunsayaci/ui/views/settings/settings_page.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create',
      name: 'create',
      builder: (context, state) {
        final args = state.uri.queryParameters;
        return CreatePage(
          isFirst: args['isFirst'] as bool,
          dataModel: state.extra as DataModel?,
        );
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);
