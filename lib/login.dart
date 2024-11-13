import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk JSON decoding
import 'dashboard.dart'; // Import dashboard

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _isHide = true;
  bool _isOnValidation = false;

  @override
  @override
Widget build(BuildContext context) {

  return Scaffold(
    backgroundColor: Colors.white, // Set background color to white
    body: SingleChildScrollView(  // Membungkus dengan SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const SizedBox(
              height: 200,
              child: Image(
                image: AssetImage('assets/images/logo.png'), // Path gambar logo Anda
                fit: BoxFit.contain, // Menyesuaikan ukuran logo
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Welcome!\nto ', // Teks 'Welcome! to' berwarna hitam
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'BelajarMabrur', // Teks 'BelajarMabrur' berwarna merah #a20e0e
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA20E0E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: _isHide ? true : false,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(onPressed: () {
                  setState(() {
                    _isHide = !_isHide;
                  });
                }, icon: Icon(_isHide ? Icons.visibility_off : Icons.visibility)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, // Set the width to full
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA20E0E), // Warna merah tombol
                  padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding vertikal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isOnValidation ? const CircularProgressIndicator() : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'App developed by nextCode',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  // Function to handle login logic
  Future<void> _handleLogin() async {
    setState(() {
      _isOnValidation = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Username and password are required';
        _isOnValidation = false;
      });
      return;
    }

    try {
      final responseLogin = await http.post(
        Uri.parse('http://192.168.18.11:3000/api/users/login'), // Update with your API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (responseLogin.statusCode == 200) {
        // Login successful, proceed to fetch user details
        final body = json.decode(responseLogin.body);
        final user = body['data'];
        final token = user['token'];

        final responseUser = await http.get(
          Uri.parse('http://192.168.18.11:3000/api/users/current'), // Update with your API URL
          headers: {'Authorization': token},
        );

        if (responseUser.statusCode == 200) {
          // Successfully fetched user details
          final userBody = json.decode(responseUser.body);
          String role = userBody['data']['role'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(
                userId: username,
                role: role,
                isHost: role.toLowerCase() == 'host',
              ),
            ),
          );
        } else if (responseUser.statusCode == 403) {
          // Unauthorized access
          setState(() {
            _errorMessage = 'Access denied. You do not have permission.';
          });
        } else {
          // Any other error
          setState(() {
            _errorMessage = 'Failed to fetch user details. Please try again.';
          });
        }
      } else if (responseLogin.statusCode == 401) {
        // Invalid credentials
        setState(() {
          _errorMessage = 'Wrong username or password';
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to login. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isOnValidation = false;
      });
    }
  }

}
