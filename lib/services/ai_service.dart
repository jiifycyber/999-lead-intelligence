import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lead.dart';

class AIService {
  Future<Map<String, dynamic>> analyzeLead(Lead lead) async {
    final client = Supabase.instance.client;

    final response = await client.functions.invoke(
      'lead-intelligence-ai',
      body: {
        'name': lead.name,
        'phone': lead.phone ?? '',
        'email': lead.email ?? '',
        'source': lead.source,
        'status': lead.status,
        'score': lead.score,
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw StateError('Invalid AI response');
    }

    final result = Map<String, dynamic>.from(data);

    if (result['success'] != true) {
      throw StateError(
        result['error']?.toString() ?? 'Lead intelligence failed',
      );
    }

    return Map<String, dynamic>.from(
      result['intelligence'] as Map,
    );
  }

  Future<String> suggestNextAction({
    required String leadName,
    required String status,
  }) async {
    final response = await Supabase.instance.client.functions.invoke(
      'lead-intelligence-ai',
      body: {
        'name': leadName,
        'status': status,
        'source': 'unknown',
        'score': 0,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);
    final intelligence = Map<String, dynamic>.from(data['intelligence'] as Map);

    return intelligence['next_action']?.toString() ??
        'Review this lead manually.';
  }
}
