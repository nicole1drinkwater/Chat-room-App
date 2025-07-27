import 'package:chatroom/screens/chat_room/message_card.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:chatroom/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../../services/firestore_service.dart';
import '../../shared/styled_button.dart';
import '../../shared/styled_text.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<MessageStore>(context, listen: false)
    .fetchMessagesOnce();

    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose(); 
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
  }

  void handleSubmit() {
    if (_messageController.text.trim().isEmpty) {
      
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const StyledHeading('Missing Text'),
          content: const StyledText('Please enter your text.'),
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

      final userStore = Provider.of<UserStore>(context, listen: false);

      final currentUser = userStore.currentUser;

      final String senderId = currentUser!.id;

      Provider.of<MessageStore>(context, listen: false) 
      .addMessage(Message(
        messageContent: _messageController.text,
        timeSent: DateTime.now(),
        senderID: senderId,
        messageID: '',
      ));

      _messageController.clear();

      FocusScope.of(context).unfocus();     
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Consumer<MessageStore>(
                builder: (context, value, child) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: value.messages.length,
                    itemBuilder: (_, index) {
                      final message = value.messages[index];
                      
                      return MessageCard(message: message,);
                    }
                  );
                }
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, 

              children: [
                
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.inputTextColor,
                    ),
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
                    handleSubmit();
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