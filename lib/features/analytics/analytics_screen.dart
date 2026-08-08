import 'package:flutter/material.dart';
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Analytics & Forecasting')),body:Padding(padding:const EdgeInsets.all(20),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('Analytics & Forecasting',style:Theme.of(context).textTheme.headlineMedium),const SizedBox(height:12),const Text('Monitor lead volume, conversion rate, acquisition cost, revenue, ROI and forecasts.'),const SizedBox(height:20),const Card(child:ListTile(leading:Icon(Icons.check_circle_outline),title:Text('Module connected to app navigation'),subtitle:Text('Add provider credentials and backend functions to activate external services.')))])));
}
