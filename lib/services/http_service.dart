import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl = "https://localhost/api/";

  Future getResponse({
    required String url,
    String? token,
  }) async {
    dynamic responseJson;
    Map<String, String> headers;
    token == null
        ? headers = {
            "Accept": "application/json",
          }
        : headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
          };
    try {
      final response =
          await http.get(Uri.parse(baseUrl + url), headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future postResponse({
    required String url,
    String? token,
    required Map<String, String> body,
  }) async {
    dynamic responseJson;
    Map<String, String> headers;
    token == null
        ? headers = {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          }
        : headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
            "Content-Type": "application/x-www-form-urlencoded"
          };
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          headers: headers, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future putResponse({
    required String url,
    String? token,
    required Map<String, String> body,
  }) async {
    dynamic responseJson;
    Map<String, String> headers;
    token == null
        ? headers = {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          }
        : headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
            "Content-Type": "application/x-www-form-urlencoded"
          };
    try {
      final response = await http.put(Uri.parse(baseUrl + url),
          headers: headers, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future patchResponse({
    required String url,
    String? token,
    required Map<String, String> body,
  }) async {
    dynamic responseJson;
    Map<String, String> headers;
    token == null
        ? headers = {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          }
        : headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
            "Content-Type": "application/x-www-form-urlencoded"
          };
    try {
      final response = await http.patch(Uri.parse(baseUrl + url),
          headers: headers, body: body);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  Future deleteResponse({
    required String url,
    String? token,
  }) async {
    dynamic responseJson;
    Map<String, String> headers;
    token == null
        ? headers = {
            "Accept": "application/json",
          }
        : headers = {
            "Accept": "application/json",
            "Authorization": "Bearer " + token,
          };
    try {
      final response =
          await http.delete(Uri.parse(baseUrl + url), headers: headers);
      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server' +
                ' with status code : ${response.statusCode}');
    }
  }
}
