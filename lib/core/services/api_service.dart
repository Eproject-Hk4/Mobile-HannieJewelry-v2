import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../app/app_config.dart';


class ApiService {
  String? _authToken;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void setAuthToken(String token) {
    _authToken = token;
    _headers['Authorization'] = 'Bearer $token';
  }

  void removeAuthToken() {
    _authToken = null;
    _headers.remove('Authorization');
  }

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint : '/$endpoint'}');
    try {
      final response = await http.get(url, headers: _headers)
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));
      return _processResponse(response);
    } catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint : '/$endpoint'}');
    print('Calling API POST: $url with data: $data'); // Add this log
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(data),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));
      print('API Response: ${response.statusCode} - ${response.body}'); // Add this log
      return _processResponse(response);
    } catch (e) {
      print('API Error detail: $e'); // Add more detailed log
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(dynamic error) {
    print('API Error detail: $error'); // Add more detailed log
    if (kDebugMode) {
      print('API Error: $error');
    }
  }

  Future<dynamic> put(String endpoint, dynamic data) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint : '/$endpoint'}');
    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(data),
      ).timeout(Duration(milliseconds: AppConfig.connectTimeout));
      print('API Response: ${response.statusCode} - ${response.body}'); // Add log
      return _processResponse(response);
    } catch (e) {
      print('API Error detail: $e'); // Add detailed log
      _handleError(e);
      rethrow;
    }
  }

  Future<dynamic> delete(String endpoint) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}${endpoint.startsWith('/') ? endpoint : '/$endpoint'}');
    try {
      final response = await http.delete(url, headers: _headers)
          .timeout(Duration(milliseconds: AppConfig.connectTimeout));
      print('API Response: ${response.statusCode} - ${response.body}'); // Add log
      return _processResponse(response);
    } catch (e) {
      print('API Error detail: $e'); // Add detailed log
      _handleError(e);
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      }
      return {};
    } else {
      _handleHttpError(response);
    }
  }

  void _handleHttpError(http.Response response) {
    if (kDebugMode) {
      print('API Error: ${response.statusCode} - ${response.body}');
    }
    
    switch (response.statusCode) {
      case 401:
        throw Exception('Access denied. Please login again.');
      case 403:
        throw Exception('You do not have permission to access this resource.');
      case 404:
        throw Exception('Requested resource not found.');
      case 500:
        throw Exception('Server error. Please try again later.');
      default:
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'An unknown error occurred.';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('An error occurred: ${response.statusCode}');
        }
    }
  }
}