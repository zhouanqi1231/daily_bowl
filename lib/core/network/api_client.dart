import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../app_export.dart';
import '../../presentation/main_container_screen/controller/main_container_controller.dart';
import '../../presentation/explore_screen/controller/explore_controller.dart';
import '../../presentation/user_profile_screen/controller/user_profile_controller.dart';

class ApiClient {
  static String? _baseUrl;
  static String? _defaultApiKey;

  /// Wraps an external image URL through the API's image proxy,
  /// bypassing browser CORS restrictions on web.
  /// Returns the original URL if it's already hosted on the API server
  /// (Flask-CORS handles those) or if the base URL hasn't been loaded yet.
  static String proxyImageUrl(String originalUrl) {
    if (_baseUrl == null) return originalUrl;
    if (originalUrl.startsWith(_baseUrl!)) return originalUrl;
    return '$_baseUrl/proxy/image/?url=${Uri.encodeQueryComponent(originalUrl)}';
  }

  // init environment vars
  static Future<void> init() async {
    final String envString = await rootBundle.loadString('env.json');
    final Map<String, dynamic> envVars = jsonDecode(envString);
    _baseUrl = envVars['DBMS_BASE_URL'];
    _defaultApiKey = envVars['DBMS_API_KEY'];
  }

  static Future<Map<String, String>> _getHeaders() async {
    if (_baseUrl == null) await init();

    final prefs = await SharedPreferences.getInstance();
    final userApiKey = prefs.getString('api_key');

    return {
      'Content-Type': 'application/json',
      'dbms-api-key': userApiKey ?? _defaultApiKey ?? '',
    };
  }

  static void _checkUnauthorized(int statusCode) {
    if (statusCode == 401) {
      _handleUnauthorized();
      throw Exception('Unauthorized');
    }
  }

  static void _handleUnauthorized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_key');
    await prefs.remove('user_name');
    await prefs.remove('user_id');

    // Notify MainContainerController to update UI
    if (Get.isRegistered<MainContainerController>()) {
      final mainController = Get.find<MainContainerController>();
      mainController.isLoggedIn.value = false;
      // If we are in the "Me" tab, it will automatically switch to LoginScreen via Obx
    }

    // Refresh other controllers to guest state
    if (Get.isRegistered<ExploreController>()) {
      Get.find<ExploreController>().checkLoginStatus();
    }
    
    if (Get.isRegistered<UserProfileController>()) {
      Get.find<UserProfileController>().refreshUserProfile();
    }

    // Redirect to main container if we are on a protected page
    if (Get.currentRoute != AppRoutes.mainContainer && 
        Get.currentRoute != AppRoutes.initialRoute &&
        Get.currentRoute != AppRoutes.loginScreen) {
      Get.offAllNamed(AppRoutes.mainContainer);
    }
    
    Get.snackbar(
      'Session Expired',
      'Your session has expired. Please login again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: appTheme.red_900,
      colorText: appTheme.whiteCustom,
    );
  }

  // encapsule GET
  static Future<dynamic> get(String endpoint) async {
    if (_baseUrl == null) await init();

    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.get(url, headers: await _getHeaders());

    _checkUnauthorized(response.statusCode);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule POST
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    if (_baseUrl == null) await init();

    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    _checkUnauthorized(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isEmpty) {
        if (response.headers.containsKey('location')) {
          return {'location': response.headers['location']};
        }
        return null;
      }
      var decodedData = jsonDecode(response.body);

      if (decodedData is Map<String, dynamic> &&
          response.headers.containsKey('location')) {
        decodedData['location'] = response.headers['location'];
      }

      return decodedData;
    } else {
      throw Exception(
          'Failed to post data. Status Code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule PUT
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    if (_baseUrl == null) await init();

    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.put(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    _checkUnauthorized(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to update (PUT) data. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  // encapsule DELETE
  static Future<dynamic> delete(String endpoint) async {
    if (_baseUrl == null) await init();

    final url = Uri.parse('$_baseUrl$endpoint');
    final response = await http.delete(
      url,
      headers: await _getHeaders(),
    );

    _checkUnauthorized(response.statusCode);

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to delete data. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
