import 'package:flutter/material.dart';
class MarketingScreen extends StatelessWidget {
  const MarketingScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Marketing Studio')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Marketing Studio',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Create campaigns, social content, email sequences, promotions and reactivation flows.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
