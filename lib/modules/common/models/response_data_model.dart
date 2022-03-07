import 'dart:convert';

import 'package:http/http.dart' as http;

class ResponseData {
  int? statusCode;
  bool ok;
  bool okAndContainsData;
  var entity;
  var message;
  ResponseErrors? errors;
  String? rawResponseBody;

  ResponseData(
      {this.statusCode,
      this.entity,
      this.message,
      this.errors,
      this.ok: false,
      this.okAndContainsData: false,
      this.rawResponseBody});

  factory ResponseData.fromResponse(http.Response response) {
    var parsedJson = jsonDecode(response.body);
    return ResponseData(
      statusCode: response.statusCode,
      ok: (response.statusCode == 200 || response.statusCode == 201),
      entity: parsedJson['entity'] != null ? parsedJson['entity'] : null,
      rawResponseBody: response.body,
      okAndContainsData:
          (response.statusCode == 200 || response.statusCode == 201) &&
              (parsedJson['entity'] != null),
      message: parsedJson['message'] != null ? parsedJson['message'] : "",
      errors: parsedJson['errors'] != null
          ? parsedJson['errors'].runtimeType == String
              ? new ResponseErrors(message: parsedJson['errors'])
              : ResponseErrors.fromJson(parsedJson['errors'])
          : parsedJson['error'] != null
              ? ResponseErrors(message: parsedJson['error'])
              : null,
    );
  }
}

class ResponseErrors {
  String? message;

  ResponseErrors({
    this.message,
  });

  factory ResponseErrors.fromJson(Map<String, dynamic> parsedJson) {
    return ResponseErrors(
      message: parsedJson['message'] != null ? parsedJson['message'] : "",
    );
  }
}
