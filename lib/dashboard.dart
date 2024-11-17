import 'package:flutter/material.dart';
import 'join_page.dart';
import 'account_page.dart'; // Import halaman Account
import 'api_service.dart'; // Import ApiService for content fetching

class DashboardPage extends StatefulWidget {
  final String userId;
  final String role;
  final bool isHost;
  final String token;

  const DashboardPage({
    Key? key,
    required this.userId,
    required this.role,
    required this.isHost,
    required this.token,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService(); // Create an instance of ApiService
  List<dynamic> _contents = []; // List to store content data
  bool _isLoading = true; // Loading state
  String? _errorMessage; // Error message
  List<bool> _isExpanded = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    _fetchContents(); // Fetch contents when the page initializes
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
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: Colors.red),
        ),
      ); // Show error message if any
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
              color: const Color.fromARGB(255, 235, 235, 235), // Background color for the item (light gray)
              borderRadius: BorderRadius.circular(30.0), // Rounded corners
            ),
             // Set background color for the item (light gray)
            padding: const EdgeInsets.all(5.0), // Add padding inside the container
            child: ListTile(
              title: Text(
                content['name'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
      _buildHomePage(), // Build Home page dynamically
      JoinPage(isHost: widget.isHost, userId: widget.userId),
      AccountPage(userId: widget.userId, role: widget.role, token: widget.token),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(
                "Home",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA20E0E),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
            )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
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
