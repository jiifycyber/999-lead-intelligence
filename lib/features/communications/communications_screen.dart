import 'package:flutter/material.dart';
class CommunicationsScreen extends StatelessWidget {
  const CommunicationsScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Communications Hub')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Communications Hub',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Unify SMS, email, calls, web chat and supported social messaging channels.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
