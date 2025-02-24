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
  List<dynamic> _filteredContents = []; // List to store filtered content data
  bool _isLoading = true; // Loading state
  String? _errorMessage; // Error message
  List<bool> _isExpanded = []; // Initialize as an empty list

  // List of available categories for filtering
  List<String> _categories = ['All', 'Ihram', 'Thawaf', "Sa'i", 'Tahallul'];
  String _selectedCategory = ''; // Store selected category

  String _searchQuery = ""; // Store the search query

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
        _filteredContents = _contents; // Initially display all content
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

  // Function to filter contents based on selected category
  void _filterContents(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  // Function to apply search and category filters
  void _applyFilters() {
    setState(() {
      _filteredContents = _contents.where((content) {
        final matchesCategory = _selectedCategory.isEmpty || _selectedCategory == 'All' || content['category'] == _selectedCategory;
        final matchesSearch = _searchQuery.isEmpty || content['name'].toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Color(0xFFA20E0E)),
              ),
            ),
            onChanged: (query) {
              _searchQuery = query;
              _applyFilters();
            },
          ),
        ),

        // Display filter options (categories)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _filterContents(category),
                    child: Text(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCategory == category
                          ? const Color(0xFFA20E0E) // Red color when selected
                          : Colors.white, // White color when not selected
                      foregroundColor: _selectedCategory == category
                          ? Colors.white // White text color when selected
                          : const Color(0xFFA20E0E), // Red text color when not selected
                      side: BorderSide(
                        color: _selectedCategory == category
                            ? const Color(0xFFA20E0E) // Red border when selected
                            : const Color(0xFFA20E0E).withOpacity(0.3), // Red border with opacity when not selected
                        width: 2.0, // Border thickness
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), // Rounded corners for the button
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // Display content based on filtered contents
        Expanded(
          child: ListView.builder(
            itemCount: _filteredContents.length,
            itemBuilder: (context, index) {
              final content = _filteredContents[index];
              return Card(
                margin: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 8.0, top: 3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 245, 245), // Background color for the item (light gray)
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                  ),
                  padding: const EdgeInsets.all(5.0), // Add padding inside the container
                  child: ListTile(
                    title: Text(
                      content['name'],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content['latin'],
                          style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          content['translate_id'],
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\n" + content['description'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
