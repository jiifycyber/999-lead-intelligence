import 'package:flutter/material.dart';
class CrmScreen extends StatelessWidget {
  const CrmScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('CRM Pipeline')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('CRM Pipeline',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Track contacts, lifecycle stages, notes, opportunities, quotes and customer history.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
