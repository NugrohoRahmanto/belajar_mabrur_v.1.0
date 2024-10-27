import 'package:flutter/material.dart';
import 'audio_group.dart'; // Halaman untuk masuk ke room

class JoinPage extends StatefulWidget {
  final String userId;
  final bool isHost;

  const JoinPage({Key? key, required this.userId, required this.isHost}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController _roomIdController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color here
      appBar: AppBar(
        title: const Text('Join Meeting'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter Room ID to Join the Meeting',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomIdController,
              decoration: InputDecoration(
                labelText: 'Room ID',
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
            ElevatedButton(
              onPressed: () {
                final roomId = _roomIdController.text.trim();
                if (roomId.isEmpty) {
                  setState(() {
                    _errorMessage = 'Room ID cannot be empty';
                  });
                } else {
                  setState(() {
                    _errorMessage = null;
                  });
                  // Navigate to the Audio Room page with the given room ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AudioRoomPage(
                        roomId: roomId,
                        username: widget.userId, // Menggunakan userId dari widget
                        isHost: widget.isHost, // Menggunakan isHost dari widget
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA20E0E), // Warna merah untuk tombol
                minimumSize: const Size(double.infinity, 50), // Lebar penuh dan tinggi minimal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              child: const Text('Join Meeting',  style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
