// lib/core/network/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../errors/exceptions.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;
  
  ApiClient({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConfig.baseUrl;
  
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    print('GET Request: $uri');
    
    try {
      final response = await _client
          .get(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.connectionTimeout);
      
      print('GET Response: ${response.statusCode} for $uri');
      return _handleResponse(response);
    } catch (e) {
      print('GET Error: $e');
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(endpoint, null);
    print('POST Request: $uri');
    
    try {
      final response = await _client
          .post(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);
      
      print('POST Response: ${response.statusCode} for $uri');
      return _handleResponse(response);
    } catch (e) {
      print('POST Error: $e');
      throw _handleError(e);
    }
  }
  
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final uri = _buildUri(endpoint, null);
    print('PUT Request: $uri');
    
    try {
      final response = await _client
          .put(
            uri,
            headers: ApiConfig.defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.connectionTimeout);
      
      print('PUT Response: ${response.statusCode} for $uri');
      return _handleResponse(response);
    } catch (e) {
      print('PUT Error: $e');
      throw _handleError(e);
    }
  }
  
  Future<void> delete(String endpoint) async {
    final uri = _buildUri(endpoint, null);
    print('DELETE Request: $uri');
    
    try {
      final response = await _client
          .delete(uri, headers: ApiConfig.defaultHeaders)
          .timeout(ApiConfig.connectionTimeout);
      
      print('DELETE Response: ${response.statusCode} for $uri');
      
      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ServerException('Delete failed: ${response.statusCode}');
      }
    } catch (e) {
      print('DELETE Error: $e');
      throw _handleError(e);
    }
  }
  
  Uri _buildUri(String endpoint, Map<String, String>? queryParams) {
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    
    print('API Error Body: ${response.body}');
    
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(_getErrorMessage(response));
      case 401:
        throw UnauthorizedException(_getErrorMessage(response));
      case 403:
        throw ForbiddenException(_getErrorMessage(response));
      case 404:
        throw NotFoundException('Endpoint not found: ${response.request?.url}');
      case 429:
        throw RateLimitException(_getErrorMessage(response));
      case 500:
      case 502:
      case 503:
        throw ServerException(_getErrorMessage(response));
      default:
        throw ServerException('Request failed: ${response.statusCode}');
    }
  }
  
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['error'] ?? body['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Request failed: ${response.statusCode}';
    }
  }
  
  Exception _handleError(dynamic error) {
    if (error is AppException) {
      return error;
    }
    if (error.toString().contains('SocketException') ||
        error.toString().contains('TimeoutException')) {
      return NetworkException('No internet connection: $baseUrl');
    }
    return ServerException(error.toString());
  }
  
  void dispose() {
    _client.close();
  }
}
