import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

class ApiClient {
  static String? _baseUrl;
  static String? _apiKey;

  // init environment vars
  static Future<void> init() async {
    final String envString = await rootBundle.loadString('env.json');
    final Map<String, dynamic> envVars = jsonDecode(envString);
    _baseUrl = envVars['DBMS_BASE_URL'];
    _apiKey = envVars['DBMS_API_KEY'];
  }

  // encapsule GET
  static Future<dynamic> get(String endpoint) async {
    if (_baseUrl == null) await init();
    
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'dbms-api-key': _apiKey ?? '', 
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data. Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule POST
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    if (_baseUrl == null) await init();
    
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'dbms-api-key': _apiKey ?? '',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data. Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    if (_baseUrl == null) await init();
    
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.put(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'dbms-api-key': _apiKey ?? '', 
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      // if 204 return null to avoid json decode error
      if (response.body.isEmpty) return null; 
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update (PUT) data. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule DELETE
  static Future<dynamic> delete(String endpoint) async {
    if (_baseUrl == null) await init();
    
    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.delete(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'dbms-api-key': _apiKey ?? '', 
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}