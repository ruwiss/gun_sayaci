import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gunsayaci/common/extensions/extensions.dart';
import 'package:gunsayaci/common/models/data_model.dart';
import 'package:gunsayaci/ui/views/create/create_page.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:gunsayaci/ui/views/home/home_page.dart';
import 'package:gunsayaci/ui/views/settings/settings_page.dart';
import 'package:provider/provider.dart';

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
        return ChangeNotifierProvider(
          create: (_) => CreateProvider(),
          builder: (_, __) => CreatePage(
            isFirst: args['isFirst']!.parseBool(),
            dataModel: state.extra as DataModel?,
          ),
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

BuildContext? get getContextFromRouter =>
    router.routerDelegate.navigatorKey.currentContext;