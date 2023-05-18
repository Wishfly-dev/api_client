import 'package:wishfly_api_client/wishfly_api_client.dart';
import 'package:wishfly_shared/wishfly_shared.dart';

void main() async {
  final apiClient = WishflyApiClient(apiKey: "your-api-key");

  // Get project list
  final projects = await apiClient.getProjects();
  print(projects);

  // Get current project plan
  final projectPlan = await apiClient.getProjectPlan(id: 0); // your id
  print(projectPlan);

  // Create wish
  await apiClient.createWish(
    request: WishRequestDto(
      title: "My wish",
      description: "My wish description",
      projectId: 0, // your id
    ),
  );

  // Fetch project to added feature request
  final project = await apiClient.getProject(id: 0); // your id
  print(project);

}
