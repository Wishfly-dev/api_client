import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wishfly_api_client/src/api_failures.dart';
import 'package:wishfly_shared/wishfly_shared.dart';

class WishflyApiClient {
  /// Create an instance of [WishflyApiClient] that integrates
  /// with the remote API.
  WishflyApiClient({
    required String apiKey,
    http.Client? httpClient,
  }) : this._(
          baseUrl: 'https://api.wishfly.dev',
          apiKey: apiKey,
          httpClient: httpClient,
        );

  WishflyApiClient._({
    required String baseUrl,
    required String apiKey,
    http.Client? httpClient,
  })  : _baseUrl = baseUrl,
        _apiKey = apiKey,
        _httpClient = httpClient ?? http.Client();

  final String _baseUrl;
  final http.Client _httpClient;
  static const unknownErrorMessage = 'An unknown error occurred.';

  String get hostedUri => _baseUrl;

  /// API key used for authentication with the API.
  ///
  /// You can obtain API key from Wishfly dashboard.
  String _apiKey;

  /// GET /api/v1/project
  /// Returns list of projects.
  Future<List<ProjectResponseDto>> getProjects() async {
    final uri = Uri.parse('$_baseUrl/api/v1/project');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }

    final body = response.jsonList();

    return body.map((data) => ProjectResponseDto.fromJson(data)).toList();
  }

  /// GET /api/v1/project/<id>
  /// Requests project based in given id.
  Future<ProjectResponseDto> getProject({
    required int id,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/project/$id');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }

    final body = response.json();

    return ProjectResponseDto.fromJson(body);
  }

  /// GET /api/v1/project/<id>/detail
  /// Requests project detail information based in given id.
  Future<ProjectDetailResponseDto> getProjectPlan({
    required int id,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/project/$id/detail');
    final response = await _httpClient.get(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }

    final body = response.json();

    return ProjectDetailResponseDto.fromJson(body);
  }

  /// POST /api/v1/wish
  /// Create wish in given project [WishRequestDto.projectId]
  Future<void> createWish({required WishRequestDto request}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/wish');
    final response = await _httpClient.post(
      uri,
      body: json.encode(request.toJson()),
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.created) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }
  }

  /// POST /api/v1/wish/$id/vote
  /// Vote for selected wish
  Future<void> vote({required int wishId}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/wish/$wishId/vote');
    final response = await _httpClient.post(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.created) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }
  }

  /// DELETE /api/v1/wish/$id/vote
  /// Delete vote for selected wish
  ///
  /// Before deleting vote, check if user has voted for this wish using local storage.
  Future<void> removeVote({required int wishId}) async {
    final uri = Uri.parse('$_baseUrl/api/v1/wish/$wishId/vote');
    final response = await _httpClient.delete(
      uri,
      headers: await _getRequestHeaders(),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw _parseErrorResponse(response.body, response.statusCode);
    }
  }

  /// Setting request headers with API key
  Future<Map<String, String>> _getRequestHeaders() async {
    return <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      HttpHeaders.acceptHeader: ContentType.json.value,
      "x-api-key": _apiKey,
    };
  }

  void close() => _httpClient.close();

  /// Parses error response from API.
  ///
  /// [response] - HTTP response body in String
  /// [statusCode] - HTTP status code
  ///
  /// Status code [HttpStatus.conflict] meaning that you exceed your quota for creating feature requests
  /// or projects, then [FreemiumAccountException] is thrown.
  /// Otherwise, [WishflyException] is throw with [ErrorResponse.message] as error message.
  WishflyException _parseErrorResponse(String response, int statusCode) {
    final ErrorResponse error;

    try {
      final body = json.decode(response) as Map<String, dynamic>;
      error = ErrorResponse.fromMap(body);
    } catch (_) {
      return WishflyException(unknownErrorMessage, statusCode);
    }

    if (statusCode == HttpStatus.conflict) {
      return FreemiumAccountException(error.message);
    }

    return WishflyException(error.message, statusCode);
  }
}

extension on http.Response {
  /// Parses HTTP response body to JSON.
  ///
  /// Throws [WishflyParsingJsonException] if parsing fails.
  Map<String, dynamic> json() {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_, stackTrace) {
      throw WishflyParsingJsonException(error: "Parsing error: $stackTrace");
    }
  }

  /// Parses HTTP response body to JSON list.
  ///
  /// Throws [WishflyParsingJsonException] if parsing fails.
  List jsonList() {
    try {
      return jsonDecode(body) as List;
    } catch (_, stackTrace) {
      throw WishflyParsingJsonException(error: "Parsing error: $stackTrace");
    }
  }
}
