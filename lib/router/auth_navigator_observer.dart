import 'package:flutter/material.dart';
import 'package:openiothub/providers/auth_provider.dart';
import 'package:openiothub/router/app_routes.dart';

class AuthNavigatorObserver extends NavigatorObserver {
  final AuthProvider authProvider;
  bool _isHandlingAuthChange = false;

  AuthNavigatorObserver({required this.authProvider}) {
    authProvider.addListener(_onAuthStateChanged);
  }

  void _onAuthStateChanged() {
    if (_isHandlingAuthChange) return;

    if (!authProvider.isAuthenticated && !authProvider.isLoading) {
      _isHandlingAuthChange = true;

      Future.microtask(() {
        _isHandlingAuthChange = false;
        final navigator = this.navigator;
        if (navigator != null) {
          final currentRoute = ModalRoute.of(navigator.context);
          if (currentRoute != null) {
            final routeName = currentRoute.settings.name;
            if (routeName != null &&
                routeName != AppRoutes.login &&
                routeName != AppRoutes.register &&
                routeName != AppRoutes.root) {
              navigator.pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) =>
                    route.settings.name == AppRoutes.login ||
                    route.settings.name == AppRoutes.root,
              );
            }
          }
        }
      });
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _checkAuthAndRedirect(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _checkAuthAndRedirect(newRoute);
    }
  }

  void _checkAuthAndRedirect(Route<dynamic> route) {
    final routeName = route.settings.name;

    if (routeName != null &&
        AppRoutes.protectedRoutes.contains(routeName) &&
        !authProvider.isAuthenticated &&
        !authProvider.isLoading) {
      authProvider.loadCurrentToken().then((_) {
        Future.microtask(() {
          final navigator = this.navigator;
          if (navigator != null && !authProvider.isAuthenticated) {
            navigator.pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) =>
                  route.settings.name == AppRoutes.login ||
                  route.settings.name == AppRoutes.root,
            );
          }
        });
      });
    }
  }

  void dispose() {
    authProvider.removeListener(_onAuthStateChanged);
  }
}
