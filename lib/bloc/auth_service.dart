import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordPressAuthService {
  final Dio _dio = Dio();
  final String baseUrl;

  WordPressAuthService(this.baseUrl);
  Future<bool> login(String username, String password) async {
    final response = await _dio.post(
      '$baseUrl/wp-json/api/v1/token',
      data: {
        'username': username,
        'password': password,
      },
    );
    print(response);
    print("fqsgedsg ");
    try {


      if (response.statusCode == 200) {
        final token = response.data['jwt_token'];
        await saveToken(token);
        return true;
      } else {
        // Handle login failure
        return false;
      }
    } catch (error) {
      print('Error during login: $error');
      return false;
    }
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null;
  }
}
/*
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<void> login(String username, String password) async {
    final response = await _dio.post(
      'https://www.drg.deveoo.net/wp-json/api/v1/token',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(contentType: Headers.jsonContentType),
    );

    print("fdsges");
    print(response);
    print("Request data: ${response.requestOptions.data}");
    print("Request headers: ${response.requestOptions.headers}");
    try {
      if (response.statusCode == 200) {
        final jwtToken = response.data['jwt_token'];
        await saveToken(jwtToken);
      } else {
        throw Exception('Login failed');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }


  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt_token');
  }
}*/