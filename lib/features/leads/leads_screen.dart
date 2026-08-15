import 'package:flutter/material.dart';
import '../../models/lead.dart';
import '../../services/ai_service.dart';
import '../../services/lead_service.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  final LeadService _leadService = LeadService();
  final AIService _aiService = AIService();
  final Set<String> _analyzing = {};
  final Map<String, Map<String, dynamic>> _results = {};

  Future<void> _analyzeLead(Lead lead) async {
    setState(() {
      _analyzing.add(lead.id);
    });

    try {
      final result = await _aiService.analyzeLead(lead);

      if (!mounted) return;

      setState(() {
        _results[lead.id] = result;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('AI analysis failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _analyzing.remove(lead.id);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('999 Lead Intelligence'),
      ),
      body: FutureBuilder<List<Lead>>(
        future: _leadService.fetchLeads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Lead connection error: ${snapshot.error}',
              ),
            );
          }

          final leads = snapshot.data ?? [];

          if (leads.isEmpty) {
            return const Center(
              child: Text(
                'No leads yet. Configure Supabase and add records to the leads table.',
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: leads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lead = leads[index];
              final intelligence = _results[lead.id];
              final isAnalyzing = _analyzing.contains(lead.id);

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: Text('${lead.score}'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lead.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${lead.source} • ${lead.status}',
                                ),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed:
                                isAnalyzing ? null : () => _analyzeLead(lead),
                            icon: isAnalyzing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                              isAnalyzing ? 'Analyzing' : 'Analyze AI',
                            ),
                          ),
                        ],
                      ),
                      if (intelligence != null) ...[
                        const Divider(height: 28),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(
                              label: Text(
                                'Priority: ${intelligence['priority'] ?? 'unknown'}',
                              ),
                            ),
                            Chip(
                              label: Text(
                                'AI Score: ${intelligence['recommended_score'] ?? lead.score}',
                              ),
                            ),
                            Chip(
                              label: Text(
                                'Contact: ${intelligence['contact_method'] ?? 'none'}',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoRow(
                          label: 'Next Action',
                          value: intelligence['next_action']?.toString() ?? '',
                        ),
                        _InfoRow(
                          label: 'Why',
                          value: intelligence['reason']?.toString() ?? '',
                        ),
                        _InfoRow(
                          label: 'Follow Up',
                          value: intelligence['follow_up_timing']?.toString() ??
                              '',
                        ),
                        _InfoRow(
                          label: 'Sales Message',
                          value:
                              intelligence['sales_message']?.toString() ?? '',
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
