import 'package:flutter/material.dart';
class AutomationScreen extends StatelessWidget {
  const AutomationScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Automation Builder')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Automation Builder',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Create rule-based workflows for follow-ups, missed calls, quote expiration and customer reactivation.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
