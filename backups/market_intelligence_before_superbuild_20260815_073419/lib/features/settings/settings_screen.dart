import 'package:flutter/material.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Settings & Integrations')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Settings & Integrations',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Configure Supabase, communications, ad platforms, WordPress, CallRail, maps and business settings.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
