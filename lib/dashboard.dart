import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'join_page.dart';
import 'account_page.dart';
import 'api_service.dart';

class DashboardPage extends StatefulWidget {
  final String userId;
  final String role;
  final bool isHost;
  final String token;

  const DashboardPage({
    super.key,
    required this.userId,
    required this.role,
    required this.isHost,
    required this.token,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService(); // Create an instance of ApiService
  List<dynamic> _contents = []; // List to store content data
  bool _isLoading = true; // Loading state
  String? _errorMessage;
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  // Function to fetch contents
  Future<void> _fetchContents() async {
    final result = await _apiService.getContents();

    if (result['success']) {
      setState(() {
        _contents = result['data'];
        _isExpanded = List.generate(_contents.length, (index) => false); // Initialize expanded state
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = result['error'];
        _isLoading = false;
      });
    }
  }

  // Function to build Home page
  Widget _buildHomePage() {
    if (_isLoading) {
      return Center(child: Platform.isIOS ? CupertinoActivityIndicator() : CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: TextStyle(color: Platform.isIOS ? CupertinoColors.destructiveRed : Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: _contents.length,
      itemBuilder: (context, index) {
        final content = _contents[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Platform.isIOS ? CupertinoColors.systemGrey5 : Color.fromARGB(255, 235, 235, 235), // Different background color for iOS and Android
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                content['name'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                setState(() {
                  _isExpanded[index] = !_isExpanded[index]; // Toggle expanded state
                });
              },
              subtitle: _isExpanded[index]
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    content['arabic'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content['latin'],
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content['translate_id'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${content['category']}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content['description'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
                  : null,
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      _buildHomePage(),
      JoinPage(isHost: widget.isHost, userId: widget.userId),
      AccountPage(userId: widget.userId, role: widget.role, token: widget.token),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? Platform.isIOS
          ? const CupertinoNavigationBar(
        middle: Text("Home", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: CupertinoColors.white,
      )
          : AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFA20E0E)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.add_circled),
            label: 'Join',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        activeColor: Color(0xFFA20E0E),
        onTap: _onItemTapped,
      )
          : BottomNavigationBar(
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
        selectedItemColor: const Color(0xFFA20E0E),
        unselectedItemColor: const Color.fromARGB(255, 139, 139, 139),
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
