import 'package:chatroom/models/message.dart';
import 'package:chatroom/models/user.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:chatroom/shared/styled_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();
    final currentUser = userStore.currentUser;
    final bool isSender = currentUser?.id == message.senderID;

    return FutureBuilder<User>(
      future: userStore.getUserData(message.senderID),
      builder: (context, userSnapshot) {

        final senderName = userSnapshot.data?.name ?? 'Unknown User';

        return Padding(

          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(

            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [

              //Maybe remove this condition : Bubble messages tjay display the msg and your name above the msg
              if (!isSender)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: StyledText(senderName), 
                ),
              
              BubbleSpecialThree(
                text: message.messageContent,
                color: isSender
                    ? Theme.of(context).colorScheme.primary 
                    : const Color.fromRGBO(232, 232, 238, 1), 
                tail: true,
                isSender: isSender,
                textStyle: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}