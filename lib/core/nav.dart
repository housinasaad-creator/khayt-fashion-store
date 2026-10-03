import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> shellKey = GlobalKey<ScaffoldState>();
final ValueNotifier<String> currentPath = ValueNotifier<String>('/');

class PathObserver extends NavigatorObserver {
  void _set(Route<dynamic>? r) {
    final n = r?.settings.name;
    if (n != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => currentPath.value = n);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) => _set(route);
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _set(previousRoute);
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) => _set(newRoute);
}

class Go {
  /// Top-level navigation: replaces the whole stack.
  static void top(String path) {
    final nav = navKey.currentState;
    if (nav == null) return;
    if (currentPath.value == path) return;
    nav.pushNamedAndRemoveUntil(path, (r) => false);
  }

  /// Drill-down navigation: keeps history so Back works.
  static void push(String path) => navKey.currentState?.pushNamed(path);
  static void product(String id) => push('/product/$id');
  static void back() => navKey.currentState?.maybePop();
  static void openCart() => shellKey.currentState?.openEndDrawer();
  static void closeDrawers() {
    final s = shellKey.currentState;
    if (s == null) return;
    if (s.isDrawerOpen) s.closeDrawer();
    if (s.isEndDrawerOpen) s.closeEndDrawer();
  }
}
