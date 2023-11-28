import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextExtensions on BuildContext {
  void pushNamedRemoveUntil() {
    while (canPop()) {
      pop();
    }
    pushNamed('home');
  }

}
