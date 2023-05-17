import 'package:wishfly_api_client/wishfly_api_client.dart';

void main() async {
  final apiClient = WishflyApiClient(apiKey: "your-api-key");

  // Get project list
  final projects = await apiClient.getProjects();
  print(projects);

  /// Get current project plan
  final projectPlan = await apiClient.getProjectPlan(id: 0); // your id
  print(projectPlan);
}
