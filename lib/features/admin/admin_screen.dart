import 'package:flutter/material.dart';
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Administration')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Administration',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Manage companies, users, roles, permissions, subscriptions and audit activity.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
