import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import 'package:uuid/uuid.dart';
import '../../models/user.dart';
import '../../services/push_notifications.dart';
import '../../services/user_store.dart';
import '../../shared/styled_text.dart';
import '../../shared/styled_button.dart';

var uuid = const Uuid();

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (_nameController.text.trim().isEmpty){
      
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const StyledHeading('Missing Name'),
          content: const StyledText('Please enter your name.'),
          actions: [
            StyledButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const StyledHeading('Close'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      });

      return;
    }

    final fcmToken = await PushNotifications.getFCMToken();

    if (fcmToken == null) {
      print("Failed to get FCM token.");
    }

    final newUser = User(
      name: _nameController.text.trim(),
      id: uuid.v4(),
      fcmToken: fcmToken,
    );

    await Provider.of<UserStore>(context, listen: false) 
    .addUser(newUser);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', newUser.id);

      Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => const ChatRoomScreen(),
    ));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
              TextField(
              controller: _nameController,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.inputTextColor,
              ),
              decoration: const InputDecoration(
              hintText: 'Enter your name',
            )
            ),

            StyledButton(
              onPressed: () {
                handleSubmit();
              },
              child: const StyledText('Sign up'),
            ),
          ]
        ),
      ),
    );
  }
  }