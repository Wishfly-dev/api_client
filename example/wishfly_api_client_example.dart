import 'package:wishfly_api_client/client.dart';

void main() async {
  final apiClient = WishflyApiClient(apiKey: "your-api-key");
  final projects = await apiClient.getProjects();
  print(projects);
}
