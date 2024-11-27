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
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience(); // Audience hanya mendengarkan

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveAudioRoom(
        appID: appID,
        appSign: appSign,
        userID: userID, // UserID harus unik untuk setiap pengguna
        userName: username,
        roomID: roomId,
        config: roomConfig, // Konfigurasi berdasarkan apakah host atau audience
      ),
    );
  }
}
