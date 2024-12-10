import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AudioRoomPage extends StatelessWidget {
  final String roomId;
  final String username;
  final bool isHost;

  const AudioRoomPage({
    Key? key,
    required this.roomId,
    required this.username,
    required this.isHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan App ID dan App Sign dari Zego
    final int appID = int.parse(dotenv.env['APP_ID'] ?? '0000');
    final String appSign = dotenv.env['APP_SIGN'] ?? 'default';

    // Menggunakan username sebagai userID yang unik
    final String userID = username;

    // Konfigurasi room sesuai dengan apakah host atau audience
    final roomConfig = isHost
        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host() // Host memiliki hak siaran
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
    ..pip.enableWhenBackground = true
    ..topMenuBar.buttons = [
      ZegoLiveAudioRoomMenuBarButtonName.pipButton
    ]; // Audience hanya mendengarkan

    // Menambahkan tombol minimisasi ke dalam konfigurasi top menu
    roomConfig.topMenuBar.buttons = [
      ZegoLiveAudioRoomMenuBarButtonName.minimizingButton,
    ];


    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: appID,
        appSign: appSign,
        userID: userID, // UserID harus unik untuk setiap pengguna
        userName: username,
        roomID: roomId,
        config: roomConfig // Konfigurasi berdasarkan apakah host atau audience
          ..background = background(),
      ),
    );
  }

  // Method untuk background dengan text overlay
  Widget background() {
    return Stack(
      children: [
        // Background dengan warna solid (misalnya biru muda)
        Container(
          color: const Color(0xBF3131) // Ganti dengan warna yang diinginkan
        ),
        // Text overlay pada bagian atas

        Positioned(
          top: 10,
          left: 10,
          bottom: 100,
          child: Text(
            "Room ID: $roomId",
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
