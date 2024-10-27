import 'package:flutter/material.dart';
import 'dashboard.dart'; // Import dashboard

// Daftar akun yang dikenali sebagai host dan audience
Map<String, String> hostUsers = {
  'host1': 'hostpass1',
};

Map<String, String> audienceUsers = {
  'user1': 'pass1',
  'user2': 'pass2',
  'user3': 'pass3',
};

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo at the top (custom logo)
            const SizedBox(
              height: 150,
              child: Image(
                image: AssetImage('assets/images/logo.png'), // Path gambar logo Anda
                fit: BoxFit.contain, // Menyesuaikan ukuran logo
              ),
            ),
            const SizedBox(height: 20),
            // Welcome text with "BelajarMabrur" in red and "Welcome! to" in black
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
            const SizedBox(height: 40),
            // Username Field (accepts both letters and numbers)
            TextField(
              controller: _usernameController,
              // keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height:20),
            // Display error message if login fails
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            // Login button with red color #a20e0e
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
                child: const Text(
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
            // Text "App developed by nextCode" below the login button
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
    );
  }

  // Function to handle login logic
  void _handleLogin() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (hostUsers.containsKey(username) && hostUsers[username] == password) {
      // Login as host
      setState(() {
        _errorMessage = null;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(userId: username, role: 'Host', isHost: true), // Pindah ke dashboard dan kirim data akun
        ),
      );
    } else if (audienceUsers.containsKey(username) && audienceUsers[username] == password) {
      // Login as audience
      setState(() {
        _errorMessage = null;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(userId: username, role: 'User', isHost: false), // Pindah ke dashboard dan kirim data akun
        ),
      );
    } else {
      // Login failed, show error message
      setState(() {
        _errorMessage = 'Invalid username or password';
      });
    }
  }
}
