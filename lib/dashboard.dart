import 'package:flutter/material.dart';
import 'join_page.dart'; // Import halaman Join
import 'account_page.dart'; // Import halaman Account

class DashboardPage extends StatefulWidget {
  final String userId;
  final String role;
  final bool isHost;

  const DashboardPage({
    Key? key,
    required this.userId,
    required this.role,
    required this.isHost,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Widget options
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    // Update widgetOptions based on the user details
    _widgetOptions = <Widget>[
      const Center(child: Text('Home Page')), // Halaman Home
      JoinPage(isHost: widget.isHost, userId: widget.userId), // Pass `isHost` dan `userId` ke JoinPage
      AccountPage(userId: widget.userId, role: widget.role), // Halaman Account
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color here
      appBar: _selectedIndex == 0 // AppBar hanya untuk Home
          ? AppBar(
              title: Text(
                "Home", // Judul hanya untuk Home
                style: const TextStyle(
                  fontSize: 24, // Perbesar ukuran font
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA20E0E), // Warna merah untuk judul
                ),
              ),
              centerTitle: true, // Posisikan judul di tengah
              backgroundColor: Colors.white, // Warna putih untuk background AppBar
              elevation: 0, // Menghilangkan bayangan AppBar
              automaticallyImplyLeading: false, // Hilangkan tombol back
            )
          : null, // Untuk halaman Join dan Account, tidak ada AppBar
      body: _widgetOptions.elementAt(_selectedIndex), // Mengubah konten halaman berdasarkan pilihan
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Join',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFA20E0E), // Warna merah ketika dipilih
        unselectedItemColor: const Color.fromARGB(255, 139, 139, 139),
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Background putih untuk navigasi bawah
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
