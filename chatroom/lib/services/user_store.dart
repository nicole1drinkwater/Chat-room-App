import 'package:chatroom/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserStore extends ChangeNotifier {
  final List<User> _users = [];

 get users => _users;

 void addUser(User user) {
  //saves to database
  FirestoreService.addUser(user);

  //updates the state within the app
  _users.add(user);
  notifyListeners();
 }

//for when the chat room screen is first loaded
 void fetchUsersOnce() async {
  if (users.length == 0) {
    final snapshot = await FirestoreService.getUsersOnce();

    for (var doc in snapshot.docs) {
      _users.add(doc.data());
    }
    notifyListeners();
  }
  
 }
}