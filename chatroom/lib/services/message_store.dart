import 'package:chatroom/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class MessageStore extends ChangeNotifier {
  final List<Message> _messages = [];

 get messages => _messages;

 void addMessage(Message message) {
  //saves to database
  FirestoreService.addMessage(message);

  //updates the state within the app
  _messages.add(message);
  notifyListeners();
 }

//for when the chat room screen is first loaded
 Future<void> fetchMessagesOnce() async {
  if (messages.length == 0) {
    final snapshot = await FirestoreService.getMessagesOnce();

    for (var doc in snapshot.docs) {
      _messages.add(doc.data());
    }
    notifyListeners();
  }
 }
}