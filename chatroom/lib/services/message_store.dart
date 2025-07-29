import 'package:chatroom/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageStore extends ChangeNotifier {
  
 late final Stream<List<Message>> messagesStream;

 final List<Message> _messages = [];

 get messages => _messages;

  MessageStore() {
    print('sessint messages stream');
    messagesStream = FirestoreService.getMessagesStream().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

 void addMessage(Message message) {
  //saves to database
  FirestoreService.addMessage(message);
 }
}