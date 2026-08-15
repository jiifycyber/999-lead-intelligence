import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeoScreen extends StatefulWidget {
  const SeoScreen({super.key});

  @override
  State<SeoScreen> createState() => _SeoScreenState();
}

class _SeoScreenState extends State<SeoScreen> {
  bool _loading = true;
  String? _error;

  List<Map<String, dynamic>> _rows = [];

  int _clicks = 0;
  int _impressions = 0;
  double _ctr = 0;
  double _position = 0;

  static const String _siteUrl = 'sc-domain:jiffyroadsideassistance.com';

  @override
  void initState() {
    super.initState();
    _loadSearchConsole();
  }

  Future<void> _loadSearchConsole() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'google-search-console?siteUrl=${Uri.encodeComponent(_siteUrl)}',
      );

      final data = Map<String, dynamic>.from(response.data as Map);

      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'Search Console request failed');
      }

      final rawRows = (data['rows'] as List? ?? []);
      final rows =
          rawRows.map((e) => Map<String, dynamic>.from(e as Map)).toList();

      int totalClicks = 0;
      int totalImpressions = 0;
      double weightedPosition = 0;

      for (final row in rows) {
        final clicks = (row['clicks'] as num?)?.toInt() ?? 0;
        final impressions = (row['impressions'] as num?)?.toInt() ?? 0;
        final position = (row['position'] as num?)?.toDouble() ?? 0;

        totalClicks += clicks;
        totalImpressions += impressions;
        weightedPosition += position * impressions;
      }

      rows.sort((a, b) {
        final aImp = (a['impressions'] as num?)?.toInt() ?? 0;
        final bImp = (b['impressions'] as num?)?.toInt() ?? 0;
        return bImp.compareTo(aImp);
      });

      setState(() {
        _rows = rows;
        _clicks = totalClicks;
        _impressions = totalImpressions;
        _ctr = totalImpressions == 0 ? 0 : totalClicks / totalImpressions;
        _position =
            totalImpressions == 0 ? 0 : weightedPosition / totalImpressions;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _opportunities {
    final items = _rows.where((row) {
      final impressions = (row['impressions'] as num?)?.toInt() ?? 0;
      final position = (row['position'] as num?)?.toDouble() ?? 0;
      final clicks = (row['clicks'] as num?)?.toInt() ?? 0;

      return impressions > 0 && clicks == 0 && position >= 8 && position <= 50;
    }).toList();

    items.sort((a, b) {
      final aImp = (a['impressions'] as num?)?.toInt() ?? 0;
      final bImp = (b['impressions'] as num?)?.toInt() ?? 0;
      return bImp.compareTo(aImp);
    });

    return items.take(8).toList();
  }

  Widget _metricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 10),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEO Command Center'),
        actions: [
          IconButton(
            tooltip: 'Refresh Search Console',
            onPressed: _loading ? null : _loadSearchConsole,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 44),
                        const SizedBox(height: 12),
                        const Text(
                          'Search Console connection error',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _loadSearchConsole,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSearchConsole,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text(
                        'Google Search Console • Last 28 Days',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text('JiffyRoadsideAssistance.com'),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _metricCard(
                            context,
                            'Clicks',
                            '$_clicks',
                            Icons.ads_click,
                          ),
                          const SizedBox(width: 10),
                          _metricCard(
                            context,
                            'Impressions',
                            '$_impressions',
                            Icons.visibility_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _metricCard(
                            context,
                            'CTR',
                            '${(_ctr * 100).toStringAsFixed(1)}%',
                            Icons.percent,
                          ),
                          const SizedBox(width: 10),
                          _metricCard(
                            context,
                            'Avg Position',
                            _position.toStringAsFixed(1),
                            Icons.leaderboard_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Top Search Queries',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ..._rows.take(12).map((row) {
                        final query =
                            (row['query'] ?? 'Unknown query').toString();
                        final clicks = (row['clicks'] as num?)?.toInt() ?? 0;
                        final impressions =
                            (row['impressions'] as num?)?.toInt() ?? 0;
                        final ctr =
                            ((row['ctr'] as num?)?.toDouble() ?? 0) * 100;
                        final position =
                            (row['position'] as num?)?.toDouble() ?? 0;

                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.search),
                            ),
                            title: Text(query),
                            subtitle: Text(
                              '$impressions impressions • '
                              '$clicks clicks • '
                              '${ctr.toStringAsFixed(1)}% CTR',
                            ),
                            trailing: Text(
                              '#${position.toStringAsFixed(1)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                      Text(
                        'SEO Opportunities',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Queries already appearing in Google that could benefit '
                        'from stronger pages, titles, content, or local SEO.',
                      ),
                      const SizedBox(height: 10),
                      if (_opportunities.isEmpty)
                        const Card(
                          child: ListTile(
                            leading: Icon(Icons.check_circle_outline),
                            title: Text('No opportunity rows detected yet'),
                            subtitle: Text(
                              'More Search Console data will appear here as '
                              'Google collects impressions.',
                            ),
                          ),
                        )
                      else
                        ..._opportunities.map((row) {
                          final query =
                              (row['query'] ?? 'Unknown query').toString();
                          final impressions =
                              (row['impressions'] as num?)?.toInt() ?? 0;
                          final position =
                              (row['position'] as num?)?.toDouble() ?? 0;

                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.trending_up),
                              title: Text(query),
                              subtitle: Text(
                                '$impressions impressions • '
                                'Average position ${position.toStringAsFixed(1)}',
                              ),
                              trailing: const Chip(
                                label: Text('Optimize'),
                              ),
                            ),
                          );
                        }),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
    );
  }
}
