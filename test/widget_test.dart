import 'package:flutter_test/flutter_test.dart';
import 'package:lead_generation_pro/main.dart';
void main(){testWidgets('dashboard renders',(tester) async{await tester.pumpWidget(const LeadGenerationProApp());expect(find.text('Lead Generation Pro'),findOneWidget);});}
