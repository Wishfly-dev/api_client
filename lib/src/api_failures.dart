import 'dart:convert';

/// Representation of JSON parsing error
class WishflyParsingJsonException implements Exception {
  final String error;
  const WishflyParsingJsonException({required this.error});
}

/// Representation of an error response from the API
class ErrorResponse {
  const ErrorResponse({
    required this.code,
    required this.message,
  });

  /// The unique error code.
  final String code;

  /// Human-readable error message.
  final String message;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
    };
  }

  factory ErrorResponse.fromMap(Map<String, dynamic> map) {
    return ErrorResponse(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ErrorResponse.fromJson(String source) => ErrorResponse.fromMap(json.decode(source));
}
