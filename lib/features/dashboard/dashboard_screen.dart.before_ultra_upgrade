import 'package:flutter/material.dart';
import '../../widgets/module_card.dart';
import '../leads/leads_screen.dart';
import '../crm/crm_screen.dart';
import '../marketing/marketing_screen.dart';
import '../seo/seo_screen.dart';
import '../automation/automation_screen.dart';
import '../communications/communications_screen.dart';
import '../analytics/analytics_screen.dart';
import '../admin/admin_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final modules =
        <({String title, String subtitle, IconData icon, Widget page})>[
      (
        title: 'Leads',
        subtitle: 'Capture, score and manage prospects',
        icon: Icons.person_search,
        page: const LeadsScreen()
      ),
      (
        title: 'CRM',
        subtitle: 'Pipeline and customer journey',
        icon: Icons.hub,
        page: const CrmScreen()
      ),
      (
        title: 'Marketing',
        subtitle: 'Campaigns and content',
        icon: Icons.campaign,
        page: const MarketingScreen()
      ),
      (
        title: 'SEO',
        subtitle: 'Audits, keywords and local SEO',
        icon: Icons.travel_explore,
        page: const SeoScreen()
      ),
      (
        title: 'Automation',
        subtitle: 'Workflow builder and follow-ups',
        icon: Icons.auto_awesome,
        page: const AutomationScreen()
      ),
      (
        title: 'Communications',
        subtitle: 'SMS, email, calls and chat',
        icon: Icons.forum,
        page: const CommunicationsScreen()
      ),
      (
        title: 'Analytics',
        subtitle: 'ROI, conversions and forecasts',
        icon: Icons.analytics,
        page: const AnalyticsScreen()
      ),
      (
        title: 'Admin',
        subtitle: 'Users, roles and business settings',
        icon: Icons.admin_panel_settings,
        page: const AdminScreen()
      ),
      (
        title: 'Settings',
        subtitle: 'Integrations and configuration',
        icon: Icons.settings,
        page: const SettingsScreen()
      ),
    ];
    return Scaffold(
        appBar: AppBar(title: const Text('Lead Generation Pro')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('AI Business Growth Command Center',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text(
              'Lead generation, CRM, marketing, SEO, communications, automation and analytics in one app.'),
          const SizedBox(height: 16),
          ...modules.map((m) => ModuleCard(
              title: m.title,
              subtitle: m.subtitle,
              icon: m.icon,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => m.page))))
        ]));
  }
}
