import 'package:flutter/material.dart';
import '../../services/lead_service.dart';
import '../../models/lead.dart';
class LeadsScreen extends StatefulWidget { const LeadsScreen({super.key}); @override State<LeadsScreen> createState()=>_LeadsScreenState(); }
class _LeadsScreenState extends State<LeadsScreen>{
 final service=LeadService();
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Leads')),body:FutureBuilder<List<Lead>>(future:service.fetchLeads(),builder:(c,s){
   if(s.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());
   if(s.hasError)return Center(child:Text('Lead connection error: ${s.error}'));
   final leads=s.data??[];
   if(leads.isEmpty)return const Center(child:Text('No leads yet. Configure Supabase and add records to the leads table.'));
   return ListView.builder(itemCount:leads.length,itemBuilder:(c,i){final l=leads[i];return ListTile(leading:CircleAvatar(child:Text('${l.score}')),title:Text(l.name),subtitle:Text('${l.source} • ${l.status}'));});
 }));
}
