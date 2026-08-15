class Lead {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String source;
  final String status;
  final int score;
  const Lead({required this.id, required this.name, this.phone, this.email, required this.source, this.status='new', this.score=0});
  factory Lead.fromMap(Map<String,dynamic> m) => Lead(id: '${m['id']}', name: m['name'] ?? '', phone: m['phone'], email: m['email'], source: m['source'] ?? 'unknown', status: m['status'] ?? 'new', score: m['score'] ?? 0);
  Map<String,dynamic> toMap() => {'id':id,'name':name,'phone':phone,'email':email,'source':source,'status':status,'score':score};
}
