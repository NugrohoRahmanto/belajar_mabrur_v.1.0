// import 'package:flutter/material.dart';
// import 'audio_group.dart';

// class JoinRoomPage extends StatefulWidget {
//   final String username;
//   final bool isHost;

//   const JoinRoomPage({
//     Key? key,
//     required this.username,
//     required this.isHost,
//   }) : super(key: key);

//   @override
//   _JoinRoomPageState createState() => _JoinRoomPageState();
// }

// class _JoinRoomPageState extends State<JoinRoomPage> {
//   final TextEditingController _roomIdController = TextEditingController();
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Join Room'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _roomIdController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Room ID',
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (_errorMessage != null)
//               Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             ElevatedButton(
//               onPressed: () {
//                 final roomId = _roomIdController.text.trim();

//                 if (roomId.isEmpty) {
//                   setState(() {
//                     _errorMessage = 'Room ID cannot be empty';
//                   });
//                   return;
//                 }

//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AudioRoomPage(
//                       roomId: roomId,
//                       username: widget.username,
//                       isHost: widget.isHost,
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Join Room'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
