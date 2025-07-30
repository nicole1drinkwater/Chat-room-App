import 'package:chatroom/screens/chat_room/message_card.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:chatroom/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/firestore_service.dart';
import '../../shared/styled_button.dart';
import '../../shared/styled_text.dart';


class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> with WidgetsBindingObserver{
  late UserStore userStore;

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);

    userStore = Provider.of<UserStore>(context, listen: false);
    userStore.updateUserStatus('online');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      userStore.updateUserStatus('online');
    }
    else {
      userStore.updateUserStatus('offline');
    }
  }

  void showOnlineUsersDialog(BuildContext build) {
    showDialog(context: context,
     builder: (context) {
      return AlertDialog(
        title: const StyledText("Online Users"),
        content: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot<User>> (
            stream: FirestoreService.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const StyledText("No users found.");
              }

              final users = snapshot.data!.docs.map((doc) => doc.data()).toList();

              final onlineUsers = users.where((u) => u.status == 'online').toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: onlineUsers.length,
                itemBuilder: (context, index) {
                  final user = onlineUsers[index];
                  return ListTile(
                    title: StyledText(user.name),
                    leading: const CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 8,
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
           child: const Text("Close"),
           )
        ],
      );
     }
     );
  }

  @override
  void dispose() {
    userStore.updateUserStatus('offline');

    WidgetsBinding.instance.removeObserver(this);

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

  void handleSubmit() async {
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

      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
          FocusScope.of(context).unfocus();
        }    
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),

        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              showOnlineUsersDialog(context);
            },
          )
        ]
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<Message>> (
                stream: Provider.of<MessageStore>(context).messagesStream,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: StyledText("No messages yet."));
                  }

                  final messages = snapshot.data!;

                  scrollToBottom();

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      final message = messages[index];
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