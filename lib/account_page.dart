import 'package:flutter/material.dart';
import 'login.dart';  // Import halaman login untuk navigasi setelah logout

class AccountPage extends StatefulWidget {
  final String userId;
  final String role;

  const AccountPage({
    Key? key,
    required this.userId,
    required this.role,
  }) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with example data
    _nameController.text = widget.userId; // Replace with actual user name
    _phoneController.text = widget.role; // Replace with actual phone number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account', // Judul di AppBar
          style: TextStyle(
            fontSize: 24, // Ukuran font besar
            fontWeight: FontWeight.bold,
            color: Color(0xFFA20E0E), // Warna merah untuk judul
          ),
        ),
        centerTitle: true, // Judul di tengah
        backgroundColor: Colors.white, // Warna putih untuk AppBar
        elevation: 0, // Hilangkan bayangan
        automaticallyImplyLeading: false, // Hilangkan tombol back
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Padding untuk keseluruhan halaman
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara vertikal
            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara horizontal
            children: [
              // Full Name Field
              const Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  
                ),
                
              ),
              const SizedBox(height: 10), // Jarak antara label dan text field
              TextField(
                enabled: false,
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Light grey background for text field
                ),
              ),
              const SizedBox(height: 20), // Jarak antar field
              
              // Phone Number Field
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10), // Jarak antara label dan text field
              TextField(
                enabled: false,
                controller: _phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Light grey background for text field
                ),
              ),
              const SizedBox(height: 40), // Jarak sebelum tombol Save

              // Save Change Button
              SizedBox(
                width: double.infinity, // Tombol penuh lebar
                height: 50, // Tinggi tombol
                child: ElevatedButton(
                  onPressed: () {
                    // Handle save changes action
                    // Simpan nama dan nomor telepon yang diubah
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA20E0E), // Warna merah tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded button
                    ),
                  ),
                  child: const Text(
                    'Save change',
                    style: TextStyle(
                      fontSize: 18, // Ukuran teks tombol
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Jarak antara tombol Save dan Logout

              // Logout Button
              SizedBox(
                width: double.infinity, // Tombol penuh lebar
                height: 50, // Tinggi tombol
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout action
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 197, 197, 197), // Warna abu-abu untuk tombol logout
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded button
                    ),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18, // Ukuran teks tombol
                      color: const Color(0xFFA20E0E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white, // Warna background putih untuk halaman
    );
  }
}
