import 'dart:io';

import 'package:chatroom/screens/chat_room/message_card.dart';
import 'package:chatroom/screens/sign_up/sign_up.dart';
import 'package:chatroom/services/message_store.dart';
import 'package:chatroom/services/user_store.dart';
import 'package:chatroom/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  File ? _selectedImage;

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isAtBottom = true;
  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addObserver(this);

    userStore = Provider.of<UserStore>(context, listen: false);
    userStore.updateUserStatus('online');

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userStore.fetchUsersOnce();
    });

  }

    void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (!_isAtBottom) setState(() => _isAtBottom = true);
      }
    } else {
      if (_isAtBottom) setState(() => _isAtBottom = false);
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    await _sendImage(File(returnedImage.path));
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;

    await _sendImage(File(returnedImage.path));
  }

  Future<void> _sendImage(File imageFile) async {
    final userStore = Provider.of<UserStore>(context, listen: false);
    final currentUser = userStore.currentUser;

    if (currentUser == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sending image...')),
    );
    
    try {

    final String fileName = '${currentUser.id}_${uuid.v4()}.jpg';
    final Reference storageRef = FirebaseStorage.instance.ref().child('chat_images').child(fileName);

    final TaskSnapshot snapshot = await storageRef.putFile(imageFile);

    final String downloadUrl = await snapshot.ref.getDownloadURL();

    final message = Message(
      messageContent: '',
      senderID: currentUser.id,
      imageUrl: downloadUrl, 
      messageType: 'image',
      messageID: '',
      timeSent: DateTime.now(),
    );
    
    Provider.of<MessageStore>(context, listen: false).addMessage(message);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image sent successfully! Please wait a moment for it to appear...')),
    );
    
  } catch (e) {
    print("Error sending image: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to send image.')),
    );
  }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      userStore.updateUserStatus('online');
      
      setState(() {
        _isAtBottom = true;
      });

      scrollToBottom();
    }
    else {
      userStore.updateUserStatus('offline');
    }
  }

  void showOnlineUsersDialog(BuildContext build) {
    showDialog(context: context,
     builder: (context) {
      return AlertDialog(
        title: const Text("Online Users",
        style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.black, 
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot<User>> (
            stream: FirestoreService.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Text("No users found.");
              }

              final users = snapshot.data!.docs.map((doc) => doc.data()).toList();

              final onlineUsers = users.where((u) => u.status == 'online').toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: onlineUsers.length,
                itemBuilder: (context, index) {
                  final user = onlineUsers[index];
                  return ListTile(
                    title: Text(user.name, style: const TextStyle(color: Colors.black)),
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
           child: const Text("Close",
                style: TextStyle(
                color: Color.fromRGBO(40, 145, 210, 1),
              ),
),
           )
        ],
      );
     }
     );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _messageController.dispose();
    _scrollController.dispose(); 
    super.dispose();
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
        messageType: 'Text',
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
        title: const Text('Chat room',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),

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

                if (_isAtBottom && messages.length > _previousMessageCount) {
                  scrollToBottom();
                }

                _previousMessageCount = messages.length;

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: messages.map((message) {
                      return MessageCard(
                        message: message,

                          onImageLoaded: () {
                          if (_isAtBottom) {
                            scrollToBottom();
                          }
                        },
                      );
                    }).toList(),
                  ),
                );
              },
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
                    decoration: InputDecoration(
                      hintText: 'Enter a message...',
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      isDense: true,

                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(icon: const Icon(Icons.attach_file),
                          onPressed: _pickImageFromGallery,
                          tooltip: 'Choose from the gallery',
                          ),
                          IconButton(icon: const Icon(Icons.camera_alt_outlined),
                          onPressed: _pickImageFromCamera,
                          tooltip: 'Take a picture',
                          )
                        ],
                      ),
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