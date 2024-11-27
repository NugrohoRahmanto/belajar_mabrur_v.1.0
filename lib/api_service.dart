// lib/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base url (ubah url sesuai dengan server)
  final String _baseUrl = 'http://192.168.18.11:3000/api';
  final String _apiKey = 'gfijpcFdjZ5muSZ62kRCQet4ptgfrqqvfADVuKiblR84xXIB8C0urih3ywgrAwrdLbXCPTytmxfkMToGsq07UkgO065iV9H8VLeuW';

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('Login URL: ${Uri.parse('$_baseUrl/users/login')}');

      final responseLogin = await http.post(
        Uri.parse('$_baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print(responseLogin);

      if (responseLogin.statusCode == 200) {
        final body = json.decode(responseLogin.body);
        final user = body['data'];
        final token = user['token'];

        final responseUser = await http.get(
          Uri.parse('$_baseUrl/users/current'),
          headers: {'Authorization': token},
        );

        if (responseUser.statusCode == 200) {
          final userBody = json.decode(responseUser.body);
          return {
            'success': true,
            'role': userBody['data']['role'],
            'username': username,
            'token': token,
          };
        } else if (responseUser.statusCode == 403) {
          return {'success': false, 'error': 'Access denied. You do not have permission.'};
        } else {
          return {'success': false, 'error': 'Failed to fetch user details. Please try again.'};
        }
      } else if (responseLogin.statusCode == 401) {
        return {'success': false, 'error': 'Wrong username or password'};
      } else {
        return {'success': false, 'error': 'Failed to login. Please try again.'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }

  // New function to get contents
  Future<Map<String, dynamic>> getContents() async {
    print('Fetching contents...');
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/contents'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': '$_apiKey', 
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return {'success': true, 'data': body['data']};
      } else {
        print('Failed to fetch contents. Status code: ${response.statusCode}');
        return {'success': false, 'error': 'Failed to fetch contents. Please try again.'};
      }
    } catch (e) {
      print('Error: $e');
      return {'success': false, 'error': 'Error: $e'};
    }
  }
  // Function to handle logout
  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/users/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'error': 'Failed to logout. Please try again.'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Error: $e'};
    }
  }
}
