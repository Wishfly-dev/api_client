import 'dart:convert';

import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:wishfly_api_client/wishfly_api_client.dart';
import 'package:wishfly_shared/wishfly_shared.dart';

import 'wishfly_api_client_test.mocks.dart';

@GenerateMocks([Client])
void main() {
  late MockClient httpClient;
  late WishflyApiClient apiClient;

  setUp(() {
    // ignore: unused_local_variable

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-api-key': ''
    };
    
    httpClient = MockClient();
    apiClient = WishflyApiClient(
      apiKey: 'test_api_key',
      httpClient: httpClient,
    );
  });

  group('Wishfly API client', () {
    test('client can be instantiated', () {
      expect(WishflyApiClient(apiKey: ''), isNotNull);
    });

    group('project', () {
      final projects = [
        ProjectResponseDto(
          id: 1,
          title: 'Wishfly',
          description: 'description',
          uniqueId: 'id',
          apiKey: 'api-key',
          createdAt: DateTime.now(),
          wishes: [],
        ),
      ];

      test('should fetch all projects', () async {
        when(httpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(jsonEncode(projects), 200));

        final projectsResponse = await apiClient.getProjects();
        expect(projectsResponse, TypeMatcher<List<ProjectResponseDto>>());
        expect(projectsResponse.length, projects.length);

        for (final project in projects) {
          expect(projectsResponse, contains(project));
        }
      });

      test('should fetch project details', () async {
        final currentPlan = ProjectDetailResponseDto(currentPlan: "free");

        when(httpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => Response(jsonEncode(currentPlan), 200));

        final projectsResponse = await apiClient.getProjectPlan(id: 0);
        expect(projectsResponse, TypeMatcher<ProjectDetailResponseDto>());
        expect(projectsResponse.currentPlan, "free");
      });

      test('should fetch project based on given ID', () async {
        when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => Response(jsonEncode(projects.first.toJson()), 200),
        );

        final project = projects.first;

        final projectResponse = await apiClient.getProject(id: 1);
        expect(projectResponse, TypeMatcher<ProjectResponseDto>());
        expect(projectResponse, isNotNull);
        expect(projectResponse.uniqueId, project.uniqueId);
        expect(projectResponse.title, project.title);
        expect(projectResponse.description, project.description);
        expect(projectResponse.wishes.length, project.wishes.length);
        expect(projectResponse.apiKey, project.apiKey);
      });
    });

    group('wishes', () {
      test('should create a wish', () async {
        final request = WishRequestDto(title: "", description: "", projectId: 0);
        when(
          httpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonEncode(request),
          ),
        ).thenAnswer((_) async => Response('', 201));

        expect(
          apiClient.createWish(request: request),
          isA<Future<void>>(),
        );
      });

      test('should throw [FreemiumAccountException] if status 409 is returned', () async {
        final request = WishRequestDto(title: "", description: "", projectId: 0);

        when(
          httpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonEncode(request),
          ),
        ).thenAnswer((_) async => Response('{ "code": 409, "message": "" }', 409));

        expect(
          apiClient.createWish(request: request),
          throwsA(isA<FreemiumAccountException>()),
        );
      });

      test("should throw [WishflyException] if error response couldn't be parsed ", () async {
        final request = WishRequestDto(title: "", description: "", projectId: 0);

        when(
          httpClient.post(
            any,
            headers: anyNamed('headers'),
            body: jsonEncode(request),
          ),
        ).thenAnswer((_) async => Response('', 404));

        expect(
          apiClient.createWish(request: request),
          throwsA(isA<WishflyException>()),
        );
      });

      test('should create a new vote', () async {
        when(httpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 201));

        expect(
          apiClient.vote(wishId: 1),
          isA<Future<void>>(),
        );
      });

      test('throws exception if the http request fails', () async {
        when(httpClient.post(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 400));

        expect(
          apiClient.vote(wishId: 1),
          throwsA(
            isA<WishflyException>().having(
              (e) => e.message,
              'message',
              WishflyApiClient.unknownErrorMessage,
            ),
          ),
        );
      });

      test('should remove created vote', () async {
        when(httpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 200));

        expect(
          apiClient.removeVote(wishId: 1),
          isA<Future<void>>(),
        );
      });

      test('throws exception if the http request fails', () async {
        when(httpClient.delete(any, headers: anyNamed('headers'))).thenAnswer((_) async => Response('', 400));

        expect(
          apiClient.removeVote(wishId: 1),
          throwsA(
            isA<WishflyException>().having(
              (e) => e.message,
              'message',
              WishflyApiClient.unknownErrorMessage,
            ),
          ),
        );
      });
    });
  });
}
