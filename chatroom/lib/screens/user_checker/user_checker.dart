import 'package:chatroom/main.dart';
import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/user_store.dart';

class UserChecker extends StatefulWidget {
  const UserChecker({super.key});

  @override
  State<UserChecker> createState() => _UserCheckerState();
}

class _UserCheckerState extends State<UserChecker> {
  @override
  void initState() {
    super.initState();

     _checkUserSessionAndNavigate();
  }

  Future<void> _checkUserSessionAndNavigate() async {
    final userStore = Provider.of<UserStore>(context, listen: false);

    final prefs = await SharedPreferences.getInstance();

    final userID = prefs.getString('userID');

    if (!mounted) return;

    if (userID != null) {
      await userStore.loadUser(userID);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatRoomScreen()),
      );

    }
    else {
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Welcome Page'))
       );
      }  

    FlutterNativeSplash.remove();
    }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}