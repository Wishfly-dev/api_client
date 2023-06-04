import 'package:wishfly_api_client/wishfly_api_client.dart';
import 'package:wishfly_shared/wishfly_shared.dart';

void main() async {
  // Your project id
  final yourProjectId = 0;

  final apiClient = WishflyApiClient(apiKey: "your-api-key");

  // Get project list
  final projects = await apiClient.getProjects();
  print(projects);

  // Fetch project to added feature request
  final project = await apiClient.getProject(id: yourProjectId);
  print(project);

  // Get labels
  final labels = await apiClient.getProjectLabels(id: yourProjectId);
  print(labels);

  /// Create wish
  await apiClient.updateWish(
    request: WishUpdateRequestDto(
      id: 0, // wish id
      labels: [labels.first.id],
      projectId: yourProjectId,
    ),
  );

  /// Get current project plan
  final projectPlan = await apiClient.getProjectPlan(id: yourProjectId);
  print(projectPlan);

  /// Create wish
  await apiClient.createWish(
    request: WishRequestDto(
      title: "My wish",
      description: "My wish description",
      projectId: yourProjectId,
    ),
  );
}
