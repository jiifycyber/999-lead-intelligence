import 'package:flutter/material.dart';

import '../admin/admin_screen.dart';
import '../analytics/analytics_screen.dart';
import '../automation/automation_screen.dart';
import '../communications/communications_screen.dart';
import '../crm/crm_screen.dart';
import '../leads/leads_screen.dart';
import '../marketing/marketing_screen.dart';
import '../seo/seo_screen.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const bg = Color(0xFF030812);
  static const panel = Color(0xFF071120);
  static const panel2 = Color(0xFF0B1426);
  static const border = Color(0xFF182945);

  static const purple = Color(0xFF7B4DFF);
  static const blue = Color(0xFF2787FF);
  static const cyan = Color(0xFF19D7FF);
  static const green = Color(0xFF31E69A);
  static const orange = Color(0xFFFF9D38);

  void _open(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _openAgentDuke() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .78),
      builder: (_) => const _AgentDukeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final desktop = width >= 1180;
    final tablet = width >= 760;

    final modules = [
      _ModuleData(
        title: 'LEAD INTELLIGENCE',
        subtitle: 'Capture, score, prioritize and manage leads',
        icon: Icons.groups_2_outlined,
        accent: purple,
        status: 'LIVE DATA',
        onTap: () => _open(const LeadsScreen()),
      ),
      _ModuleData(
        title: 'CRM INTELLIGENCE',
        subtitle: 'Customer pipeline, follow-ups and journey management',
        icon: Icons.account_tree_outlined,
        accent: blue,
        status: 'ACTIVE',
        onTap: () => _open(const CrmScreen()),
      ),
      _ModuleData(
        title: 'MARKETING INTELLIGENCE',
        subtitle: 'Campaigns, content, ads and growth intelligence',
        icon: Icons.campaign_outlined,
        accent: purple,
        status: 'AI POWERED',
        onTap: () => _open(const MarketingScreen()),
      ),
      _ModuleData(
        title: 'SEARCH INTELLIGENCE',
        subtitle: 'Google Search Console, keywords, rankings and SEO insights',
        icon: Icons.search,
        accent: green,
        status: 'GOOGLE',
        onTap: () => _open(const SeoScreen()),
      ),
      _ModuleData(
        title: 'AUTOMATION CORE',
        subtitle: 'Workflow automation, triggers and smart follow-ups',
        icon: Icons.smart_toy_outlined,
        accent: cyan,
        status: 'AUTOMATED',
        onTap: () => _open(const AutomationScreen()),
      ),
      _ModuleData(
        title: 'COMMUNICATIONS',
        subtitle: 'SMS, email, calls and customer conversations',
        icon: Icons.chat_bubble_outline,
        accent: orange,
        status: 'OMNI-CHANNEL',
        onTap: () => _open(const CommunicationsScreen()),
      ),
      _ModuleData(
        title: 'ANALYTICS ENGINE',
        subtitle: 'Reports, dashboards, KPIs and business forecasting',
        icon: Icons.bar_chart_rounded,
        accent: blue,
        status: 'REAL-TIME',
        onTap: () => _open(const AnalyticsScreen()),
      ),
      _ModuleData(
        title: 'ADMINISTRATION',
        subtitle: 'Users, roles, permissions and system management',
        icon: Icons.shield_outlined,
        accent: purple,
        status: 'SECURE',
        onTap: () => _open(const AdminScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: bg,
      drawer: desktop
          ? null
          : _MobileDrawer(
              open: _open,
            ),
      body: SafeArea(
        child: Row(
          children: [
            if (desktop)
              SizedBox(
                width: 215,
                child: _Sidebar(
                  open: _open,
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: _CyberBackground(),
                  ),
                  Column(
                    children: [
                      _TopBar(
                        desktop: desktop,
                        openAgent: _openAgentDuke,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            desktop ? 18 : 12,
                            14,
                            desktop ? 18 : 12,
                            28,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1550),
                              child: desktop
                                  ? _DesktopDashboard(
                                      modules: modules,
                                      openAgent: _openAgentDuke,
                                      open: _open,
                                    )
                                  : _MobileDashboard(
                                      tablet: tablet,
                                      modules: modules,
                                      openAgent: _openAgentDuke,
                                      open: _open,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopDashboard extends StatelessWidget {
  final List<_ModuleData> modules;
  final VoidCallback openAgent;
  final void Function(Widget page) open;

  const _DesktopDashboard({
    required this.modules,
    required this.openAgent,
    required this.open,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 7,
          child: Column(
            children: [
              const _Hero(),
              const SizedBox(height: 12),
              _ModuleSection(modules: modules),
              const SizedBox(height: 14),
              _QuickActions(
                open: open,
                openAgent: openAgent,
              ),
              const SizedBox(height: 12),
              const _Footer(),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 390,
          child: Column(
            children: [
              _AgentDukeCard(onTap: openAgent),
              const SizedBox(height: 12),
              const _LiveOverview(),
              const SizedBox(height: 12),
              const _RecentActivity(),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  final bool tablet;
  final List<_ModuleData> modules;
  final VoidCallback openAgent;
  final void Function(Widget page) open;

  const _MobileDashboard({
    required this.tablet,
    required this.modules,
    required this.openAgent,
    required this.open,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _Hero(),
        const SizedBox(height: 12),
        _AgentDukeCard(onTap: openAgent),
        const SizedBox(height: 12),
        _ModuleSection(
          modules: modules,
          forcedColumns: tablet ? 2 : 1,
        ),
        const SizedBox(height: 12),
        const _LiveOverview(),
        const SizedBox(height: 12),
        const _RecentActivity(),
        const SizedBox(height: 12),
        _QuickActions(
          open: open,
          openAgent: openAgent,
        ),
        const SizedBox(height: 12),
        const _Footer(),
      ],
    );
  }
}

class _Sidebar extends StatelessWidget {
  final void Function(Widget page) open;

  const _Sidebar({
    required this.open,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF040A14),
        border: Border(
          right: BorderSide(color: Color(0xFF16243D)),
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(17, 20, 14, 22),
            child: Row(
              children: [
                _Logo(),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '999 LEAD\nINTELLIGENCE',
                    style: TextStyle(
                      color: Colors.white,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const _SelectedSidebarItem(
            icon: Icons.home_outlined,
            label: 'Dashboard',
          ),
          _SidebarItem(
            icon: Icons.groups_2_outlined,
            label: 'Leads',
            onTap: () => open(const LeadsScreen()),
          ),
          _SidebarItem(
            icon: Icons.account_tree_outlined,
            label: 'CRM',
            onTap: () => open(const CrmScreen()),
          ),
          _SidebarItem(
            icon: Icons.campaign_outlined,
            label: 'Marketing',
            onTap: () => open(const MarketingScreen()),
          ),
          _SidebarItem(
            icon: Icons.search,
            label: 'Search (SEO)',
            onTap: () => open(const SeoScreen()),
          ),
          _SidebarItem(
            icon: Icons.auto_awesome_outlined,
            label: 'Automation',
            onTap: () => open(const AutomationScreen()),
          ),
          _SidebarItem(
            icon: Icons.chat_bubble_outline,
            label: 'Communications',
            onTap: () => open(const CommunicationsScreen()),
          ),
          _SidebarItem(
            icon: Icons.bar_chart_outlined,
            label: 'Analytics',
            onTap: () => open(const AnalyticsScreen()),
          ),
          _SidebarItem(
            icon: Icons.admin_panel_settings_outlined,
            label: 'Admin',
            onTap: () => open(const AdminScreen()),
          ),
          _SidebarItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => open(const SettingsScreen()),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(14),
            child: _SystemStatus(),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '999 INTELLIGENCE NETWORK',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    fontSize: 9,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Lead Intelligence Core',
                  style: TextStyle(
                    color: Color(0xFF53627B),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool desktop;
  final VoidCallback openAgent;

  const _TopBar({
    required this.desktop,
    required this.openAgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF050B15),
        border: Border(
          bottom: BorderSide(color: Color(0xFF15243C)),
        ),
      ),
      child: Row(
        children: [
          if (!desktop)
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          if (!desktop) const SizedBox(width: 4),
          if (!desktop) const _Logo(),
          const Spacer(),
          if (desktop)
            Container(
              width: 290,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF030812),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF23334E),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Color(0xFF7B8799),
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Search anything...',
                    style: TextStyle(
                      color: Color(0xFF68768C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          if (desktop) const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white70,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: openAgent,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 6,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: Color(0xFF121D30),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF31E69A),
                      size: 19,
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duke The Boss',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'Agent',
                        style: TextStyle(
                          color: Color(0xFF738199),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 30, 26, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF152B4B),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF061322),
            Color(0xFF060B17),
            Color(0xFF071523),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const Text(
            '999 LEAD INTELLIGENCE',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'COMMAND CENTER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 36,
              letterSpacing: -.7,
              color: Color(0xFF6F78FF),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Live Business Growth Intelligence Operating System',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF8C98AB),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 25),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 9,
            children: const [
              _StatusBadge(
                icon: Icons.psychology_outlined,
                text: 'AI ENGINE',
                value: 'READY',
                color: Color(0xFF31E69A),
              ),
              _StatusBadge(
                icon: Icons.travel_explore,
                text: 'SEARCH CONSOLE',
                value: 'CONNECTED',
                color: Color(0xFF25A5FF),
              ),
              _StatusBadge(
                icon: Icons.storage_outlined,
                text: 'DATA LAYER',
                value: 'LIVE',
                color: Color(0xFFC45AFF),
              ),
              _StatusBadge(
                icon: Icons.shield_outlined,
                text: 'SECURITY',
                value: 'PROTECTED',
                color: Color(0xFF31E69A),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleSection extends StatelessWidget {
  final List<_ModuleData> modules;
  final int? forcedColumns;

  const _ModuleSection({
    required this.modules,
    this.forcedColumns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xB807101E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF13243E),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          int columns = forcedColumns ?? 4;

          if (forcedColumns == null) {
            if (box.maxWidth < 850) columns = 2;
            if (box.maxWidth < 500) columns = 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'INTELLIGENCE MODULES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 13),
              GridView.builder(
                itemCount: modules.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: columns == 1 ? 1.65 : .85,
                ),
                itemBuilder: (_, index) {
                  return _ModuleCard(
                    data: modules[index],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModuleCard extends StatefulWidget {
  final _ModuleData data;

  const _ModuleCard({
    required this.data,
  });

  @override
  State<_ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<_ModuleCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: hover ? const Color(0xFF0D182A) : const Color(0xFF07101D),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: hover
                ? d.accent.withValues(alpha: .65)
                : d.accent.withValues(alpha: .25),
          ),
          boxShadow: hover
              ? [
                  BoxShadow(
                    color: d.accent.withValues(alpha: .12),
                    blurRadius: 24,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: d.onTap,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: d.accent.withValues(alpha: .12),
                      border: Border.all(
                        color: d.accent.withValues(alpha: .55),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: d.accent.withValues(alpha: .12),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Icon(
                      d.icon,
                      color: d.accent,
                      size: 23,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    d.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      d.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF9AA4B5),
                        height: 1.5,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: d.accent,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          d.status,
                          style: TextStyle(
                            color: d.accent,
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF101B2D),
                          border: Border.all(
                            color: const Color(0xFF263650),
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white70,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgentDukeCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AgentDukeCard({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF203B69),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF081428),
            Color(0xFF080D19),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF173D62),
                    Color(0xFF20165A),
                    Color(0xFF080D19),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF5E67FF),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B58FF).withValues(alpha: .30),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology_alt_outlined,
                size: 65,
                color: Color(0xFF22DEFF),
              ),
            ),
          ),
          const SizedBox(height: 17),
          const Center(
            child: Text(
              'AGENT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Center(
            child: Text(
              'DUKE THE BOSS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                height: 1.05,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFF31E69A),
                ),
                SizedBox(width: 7),
                Text(
                  'ONLINE',
                  style: TextStyle(
                    color: Color(0xFF31E69A),
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Your AI Business Growth Partner\n'
              'for leads, marketing, SEO, automation and analytics.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF9AA7B9),
                height: 1.5,
                fontSize: 10.5,
              ),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 17,
              ),
              label: const Text(
                'OPEN AGENT CHAT',
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF223CD3),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                  side: const BorderSide(
                    color: Color(0xFF39B8FF),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveOverview extends StatelessWidget {
  const _LiveOverview();

  @override
  Widget build(BuildContext context) {
    return const _SidePanel(
      title: 'LIVE OVERVIEW',
      child: Column(
        children: [
          _MetricRow(
            icon: Icons.groups_2_outlined,
            label: 'New Leads',
            value: '--',
            color: Color(0xFF2787FF),
          ),
          _MetricRow(
            icon: Icons.account_tree_outlined,
            label: 'Pipeline',
            value: '--',
            color: Color(0xFFC45AFF),
          ),
          _MetricRow(
            icon: Icons.search,
            label: 'Website Clicks',
            value: '--',
            color: Color(0xFF19D7FF),
          ),
          _MetricRow(
            icon: Icons.psychology_outlined,
            label: 'AI Actions',
            value: '--',
            color: Color(0xFFFF9D38),
          ),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return const _SidePanel(
      title: 'RECENT ACTIVITY',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Icon(
              Icons.timeline,
              color: Color(0xFF2B8FFF),
              size: 28,
            ),
            SizedBox(height: 9),
            Text(
              'Live activity will appear here',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'No fake activity is generated.',
              style: TextStyle(
                color: Color(0xFF617088),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final void Function(Widget page) open;
  final VoidCallback openAgent;

  const _QuickActions({
    required this.open,
    required this.openAgent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF07101D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF15253F),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'QUICK ACTIONS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickAction(
                icon: Icons.person_add_alt,
                label: 'Add New Lead',
                onTap: () => open(const LeadsScreen()),
              ),
              _QuickAction(
                icon: Icons.campaign_outlined,
                label: 'Create Campaign',
                onTap: () => open(const MarketingScreen()),
              ),
              _QuickAction(
                icon: Icons.psychology_outlined,
                label: 'Run AI Analysis',
                onTap: openAgent,
              ),
              _QuickAction(
                icon: Icons.analytics_outlined,
                label: 'View Reports',
                onTap: () => open(const AnalyticsScreen()),
              ),
              _QuickAction(
                icon: Icons.smart_toy_outlined,
                label: 'Automate Workflow',
                onTap: () => open(const AutomationScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: const Color(0xFF6D6FFF),
        size: 16,
      ),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF0C1527),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        side: const BorderSide(
          color: Color(0xFF1A2B47),
        ),
        textStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF06101D),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF13243E),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              '♛  Built Different. Built 999.',
              style: TextStyle(
                color: Color(0xFFFFB238),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '999 INTELLIGENCE NETWORK',
            style: TextStyle(
              color: Color(0xFF985AFF),
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          Expanded(
            child: Text(
              'Agent Duke the Boss',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF448BFF),
                fontSize: 9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentDukeDialog extends StatefulWidget {
  const _AgentDukeDialog();

  @override
  State<_AgentDukeDialog> createState() => _AgentDukeDialogState();
}

class _AgentDukeDialogState extends State<_AgentDukeDialog> {
  final controller = TextEditingController();
  final messages = <String>[
    'Agent Duke the Boss online. What do you want to work on?',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void send() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(text);
      messages.add(
        'Your Agent Duke chat interface is ready. '
        'The existing live AI service still needs to be connected '
        'to this send button before deployment.',
      );
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Container(
        width: width > 700 ? 620 : double.infinity,
        height: 600,
        decoration: BoxDecoration(
          color: const Color(0xFF07101D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF384CFF),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5046FF).withValues(alpha: .25),
              blurRadius: 40,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF182A46),
                  ),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF17254A),
                    child: Icon(
                      Icons.psychology_alt_outlined,
                      color: Color(0xFF23D8FF),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AGENT DUKE THE BOSS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'ONLINE',
                          style: TextStyle(
                            color: Color(0xFF31E69A),
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (_, i) {
                  final user = i.isOdd;

                  return Align(
                    alignment:
                        user ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      margin: const EdgeInsets.only(bottom: 9),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: user
                            ? const Color(0xFF2237B6)
                            : const Color(0xFF111C2D),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        messages[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => send(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask Agent Duke the Boss...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF607087),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF050A13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D304E),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(
                            color: Color(0xFF1D304E),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: send,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF3048D8),
                    ),
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final String title;
  final Widget child;

  const _SidePanel({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF07101D),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF15253F),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF13233B),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: color.withValues(alpha: .12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;
  final Color color;

  const _StatusBadge({
    required this.icon,
    required this.text,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: .07),
        border: Border.all(
          color: color.withValues(alpha: .20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 13,
          ),
          const SizedBox(width: 6),
          Text(
            '$text: ',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 8.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 8.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemStatus extends StatelessWidget {
  const _SystemStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFF101541),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: const Color(0xFF312C83),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SYSTEM STATUS',
            style: TextStyle(
              color: Color(0xFF32C8FF),
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 9),
          Row(
            children: [
              CircleAvatar(
                radius: 3,
                backgroundColor: Color(0xFF31E69A),
              ),
              SizedBox(width: 6),
              Text(
                'SYSTEM ONLINE',
                style: TextStyle(
                  color: Color(0xFF31E69A),
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectedSidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SelectedSidebarItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF12377A),
            Color(0xFF301361),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF564DFF),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF47C6FF),
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white70,
              size: 17,
            ),
            const SizedBox(width: 11),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF704BFF),
            Color(0xFF1B73E8),
          ],
        ),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 19,
      ),
    );
  }
}

class _CyberBackground extends StatelessWidget {
  const _CyberBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0D2741).withValues(alpha: .16)
      ..strokeWidth = .7;

    const gap = 54.0;

    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) =>
      false;
}

class _ModuleData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String status;
  final VoidCallback onTap;

  const _ModuleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.status,
    required this.onTap,
  });
}

class _MobileDrawer extends StatelessWidget {
  final void Function(Widget page) open;

  const _MobileDrawer({
    required this.open,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF040A14),
      child: SafeArea(
        child: _Sidebar(open: open),
      ),
    );
  }
}
