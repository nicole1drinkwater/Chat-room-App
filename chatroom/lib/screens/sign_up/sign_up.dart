import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../shared/styled_text.dart';
import '../../shared/styled_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledTitle('Sign up'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
            decoration: InputDecoration(
            hintText: 'Enter your name',
            border: OutlineInputBorder(),
            )
            ),

            StyledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ChatRoomScreen(),
                ));
              },
              child: const Text('Submit'),
            ),
          ]
        ),
      ),
    );
  }
}