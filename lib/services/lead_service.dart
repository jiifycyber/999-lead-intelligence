import '../models/lead.dart';
import 'supabase_service.dart';
class LeadService {
  Future<List<Lead>> fetchLeads() async {
    final client = SupabaseService.client;
    if (client == null) return const [];
    final rows = await client.from('leads').select().order('created_at', ascending: false);
    return (rows as List).map((e) => Lead.fromMap(Map<String,dynamic>.from(e))).toList();
  }
  Future<void> createLead(Lead lead) async {
    final client = SupabaseService.client;
    if (client == null) throw StateError('Supabase is not configured.');
    await client.from('leads').insert(lead.toMap());
  }
}
