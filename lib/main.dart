import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_bm/login.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

// NavigatorKey global untuk mengelola navigasi
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,  // Gunakan navigatorKey di sini
      home: LoginPage(),  // Halaman pertama yang muncul adalah LoginPage
      debugShowCheckedModeBanner: false,  // Menyembunyikan banner debug
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            // Menambahkan Overlay Zego di atas halaman
            ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayPage(
              contextQuery: () {
                return navigatorKey.currentState!.context;  // Pastikan menggunakan navigatorKey untuk akses context
              },
            ),
          ],
        );
      },
    );
  }
}
