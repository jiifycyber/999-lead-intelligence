import 'package:supabase_flutter/supabase_flutter.dart';

class WordPressService {
  SupabaseClient get _client => Supabase.instance.client;

  Future<Map<String, dynamic>> testConnection() async {
    final response = await _client.functions.invoke(
      'wordpress-seo',
      body: const {
        'action': 'test',
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw StateError('Invalid WordPress response.');
    }

    return Map<String, dynamic>.from(data);
  }

  Future<Map<String, dynamic>> createSeoDraft({
    required String query,
    required String title,
    required String meta,
  }) async {
    final response = await _client.functions.invoke(
      'wordpress-seo',
      body: {
        'action': 'create_seo_draft',
        'query': query,
        'title': title,
        'meta': meta,
      },
    );

    final data = response.data;

    if (data is! Map) {
      throw StateError('Invalid WordPress response.');
    }

    final result = Map<String, dynamic>.from(data);

    if (result['success'] != true) {
      throw StateError(
        result['error']?.toString() ?? 'WordPress draft creation failed.',
      );
    }

    return result;
  }
}
