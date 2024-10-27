import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

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
    const int appID = 1304598235; // Ganti dengan App ID yang diberikan
    const String appSign =
        "79da482fcd637aa9285e9e7d80be187a58c1837024914ec46995d5472a99da5a"; // Ganti dengan App Sign yang diberikan

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
