import 'package:chatroom/screens/chat_room/chat_room.dart';
import 'package:chatroom/theme.dart';
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
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    if (_nameController.text.trim().isEmpty){
      
      showDialog(context: context, builder: (ctx) {
        return AlertDialog(
          title: const StyledHeading('Missing Name'),
          content: const StyledText('Please enter your name.'),
          actions: [
            StyledButton(
              onPressed: () {
                Navigator.pop(ctx);
              }, 
              child: const StyledHeading('Close'),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      });

      return;
    
    }
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ChatRoomScreen(),
                ));
              },
              child: const StyledText('Sign up'),
            ),
          ]
        ),
      ),
    );
  }
  }