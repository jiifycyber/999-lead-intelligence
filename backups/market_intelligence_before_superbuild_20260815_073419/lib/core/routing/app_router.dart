import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/leads/leads_screen.dart';
import '../../features/crm/crm_screen.dart';
import '../../features/marketing/marketing_screen.dart';
import '../../features/seo/seo_screen.dart';
import '../../features/automation/automation_screen.dart';
import '../../features/communications/communications_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/admin/admin_screen.dart';
import '../../features/settings/settings_screen.dart';

class AppRouter {
  static Route<dynamic> _route(Widget child, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => child, settings: settings);
  static final router = _RouterConfig();
}

class _RouterConfig extends RouterConfig<Object> {
  _RouterConfig()
      : super(
          routerDelegate: _Delegate(),
          routeInformationParser: _Parser(),
          routeInformationProvider: PlatformRouteInformationProvider(
            initialRouteInformation: RouteInformation(
              uri: Uri.parse('/'),
            ),
          ),
        );
}

class _Parser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
          RouteInformation routeInformation) async =>
      routeInformation.uri.path;
  @override
  RouteInformation restoreRouteInformation(String configuration) =>
      RouteInformation(uri: Uri.parse(configuration));
}

class _Delegate extends RouterDelegate<String>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<String> {
  final GlobalKey<NavigatorState> _key = GlobalKey<NavigatorState>();
  String _path = '/';
  @override
  GlobalKey<NavigatorState> get navigatorKey => _key;
  @override
  String get currentConfiguration => _path;
  Widget screen(String path) => switch (path) {
        '/leads' => const LeadsScreen(),
        '/crm' => const CrmScreen(),
        '/marketing' => const MarketingScreen(),
        '/seo' => const SeoScreen(),
        '/automation' => const AutomationScreen(),
        '/communications' => const CommunicationsScreen(),
        '/analytics' => const AnalyticsScreen(),
        '/admin' => const AdminScreen(),
        '/settings' => const SettingsScreen(),
        _ => const DashboardScreen()
      };
  @override
  Widget build(BuildContext context) => Navigator(
      key: _key,
      pages: [MaterialPage(child: screen(_path))],
      onDidRemovePage: (_) {
        if (_path != '/') {
          _path = '/';
          notifyListeners();
        }
      });
  @override
  Future<void> setNewRoutePath(String configuration) async {
    _path = configuration.isEmpty ? '/' : configuration;
    notifyListeners();
  }
}
