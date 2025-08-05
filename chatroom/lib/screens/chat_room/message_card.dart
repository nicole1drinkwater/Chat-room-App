import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatroom/models/message.dart';
import 'package:chatroom/models/user.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import '../../theme.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final VoidCallback? onImageLoaded;

  const MessageCard({super.key, required this.message, this.onImageLoaded});

  @override
  Widget build(BuildContext context) {    
    final userStore = context.watch<UserStore>();
    final currentUser = userStore.currentUser;
    final bool isSender = currentUser?.id == message.senderID;

    return FutureBuilder<User>(
      future: userStore.getUserData(message.senderID),
      builder: (context, userSnapshot) {

        final senderName = userSnapshot.data?.name ?? 'Unknown User';

        Widget messageBody;
        
        if (message.messageType == 'image' && message.imageUrl != null) {
          
          final imageBubble = Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: isSender ? AppColors.primaryColor : AppColors.receivedMessage
,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: message.imageUrl!,
                placeholder: (context, url) => Container(
                  height: 250,
                  width: 250,
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) {
                  onImageLoaded?.call();
                  return Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          );

          messageBody = Align(
            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: imageBubble,
            ),
          );

        } else {
          messageBody = BubbleSpecialThree(
            text: message.messageContent,
            color: isSender ? AppColors.primaryColor : AppColors.receivedMessage,
            tail: true,
            isSender: isSender,
            textStyle: TextStyle(
              color: isSender ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0), 
          child: Column(
            crossAxisAlignment:
                isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isSender)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0, left: 12.0),
                  child: Text(
                    senderName,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              messageBody,
            ],
          ),
        );
      },
    );
  }
}