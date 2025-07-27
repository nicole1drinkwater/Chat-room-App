import 'package:chatroom/models/message.dart';
import 'package:chatroom/models/user.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();

    return FutureBuilder<User>(
      future: userStore.getUserData(message.senderID),
      builder: (context, userSnapshot) {
        
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text("..."));
        }

        final senderName = userSnapshot.data?.name ?? 'Unknown User';

        return ListTile(
          title: Text(
            senderName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(message.messageContent),
        );
      },
    );
  }
}
