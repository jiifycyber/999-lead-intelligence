import 'package:flutter/material.dart';
import '../../models/lead.dart';
import '../../services/ai_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final AIService _ai = AIService();

  final TextEditingController _name = TextEditingController(text: 'Test Lead');
  final TextEditingController _status = TextEditingController(text: 'new');
  final TextEditingController _source = TextEditingController(text: 'website');
  final TextEditingController _score = TextEditingController(text: '50');

  bool _loading = false;
  String _statusText = 'Ready';
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _status.dispose();
    _source.dispose();
    _score.dispose();
    super.dispose();
  }

  Future<void> _runAi() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _statusText = 'AI analyzing...';
      _error = null;
      _result = null;
    });

    try {
      final lead = Lead(
        id: 'manual-${DateTime.now().millisecondsSinceEpoch}',
        name: _name.text.trim().isEmpty ? 'Unnamed Lead' : _name.text.trim(),
        status: _status.text.trim().isEmpty ? 'new' : _status.text.trim(),
        source: _source.text.trim().isEmpty ? 'unknown' : _source.text.trim(),
        score: int.tryParse(_score.text.trim()) ?? 0,
      );

      final result = await _ai.analyzeLead(lead);

      if (!mounted) return;

      setState(() {
        _result = result;
        _statusText = 'AI Online';
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _statusText = 'AI Error';
        _loading = false;
      });
    }
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _resultRow(String label, dynamic value) {
    final text = value?.toString().trim() ?? '';

    if (text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final intelligence = _result?['intelligence'];

    Map<String, dynamic> intel = {};
    if (intelligence is Map) {
      intel = Map<String, dynamic>.from(intelligence);
    } else if (_result != null) {
      intel = Map<String, dynamic>.from(_result!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('999 AI Intelligence Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(
                    _error == null
                        ? Icons.smart_toy_outlined
                        : Icons.error_outline,
                    size: 34,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lead Intelligence AI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(_statusText),
                      ],
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'AI Lead Analysis',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Enter a lead below and send it to the live 999 Intelligence backend.',
          ),
          const SizedBox(height: 18),
          _field('Lead name', _name),
          const SizedBox(height: 12),
          _field('Status', _status),
          const SizedBox(height: 12),
          _field('Source', _source),
          const SizedBox(height: 12),
          _field(
            'Score',
            _score,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: _loading ? null : _runAi,
            icon: const Icon(Icons.auto_awesome),
            label: Text(
              _loading ? 'Analyzing...' : 'Run Live AI Analysis',
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SelectableText(
                  'AI backend error:\n$_error',
                ),
              ),
            ),
          ],
          if (_result != null) ...[
            const SizedBox(height: 24),
            Text(
              'AI Intelligence',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _resultRow('Priority', intel['priority']),
                    _resultRow(
                      'Recommended Score',
                      intel['recommended_score'],
                    ),
                    _resultRow(
                      'Next Action',
                      intel['next_action'],
                    ),
                    _resultRow('Reason', intel['reason']),
                    _resultRow(
                      'Contact Method',
                      intel['contact_method'],
                    ),
                    _resultRow(
                      'Follow-up Timing',
                      intel['follow_up_timing'],
                    ),
                    _resultRow(
                      'Sales Message',
                      intel['sales_message'],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
