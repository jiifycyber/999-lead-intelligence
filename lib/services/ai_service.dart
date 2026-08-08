class AiService {
  Future<String> suggestNextAction({required String leadName, required String status}) async {
    return 'Follow up with $leadName about their $status lead and confirm the next step.';
  }
}
