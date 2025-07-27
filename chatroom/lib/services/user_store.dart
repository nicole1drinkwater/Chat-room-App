import 'package:chatroom/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserStore extends ChangeNotifier {
  final List<User> _users = [
    User(id: '1', name: 'Nicole Drinkwater'),
    User(id: '2', name: 'Jane Doe'),
  ];

 get users => _users;

 void addUser(User user) {
  //saves to database
  FirestoreService.addUser(user);

  //updates the state within the app
  _users.add(user);
  notifyListeners();
 }
}