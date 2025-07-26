import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import '../../shared/styled_button.dart';
import '../../shared/styled_text.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                Text('Messages will appear here'),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                  ),
                ),
                
                const SizedBox(width: 8), 

                IconButton(
                  onPressed: () {
                  },
                  icon: Icon(Icons.send, color: AppColors.primaryColor,),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}