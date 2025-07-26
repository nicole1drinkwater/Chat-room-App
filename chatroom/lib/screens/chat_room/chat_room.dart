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
            padding: const EdgeInsets.all(9.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, 

              children: [
                
                Expanded(
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      isDense: true,
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