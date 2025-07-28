import 'package:chatroom/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserStore extends ChangeNotifier {
  final List<User> _users = [];
  User? _currentUser; 
 
  User? get currentUser => _currentUser;

  get users => _users;

 void addUser(User user) {
  //saves to database
  FirestoreService.addUser(user);

  //updates the state within the app
  _users.add(user);

  _currentUser = user;

  notifyListeners();
 }

//for when the chat room screen is first loaded
 void fetchUsersOnce() async {
  if (users.length == 0) {
    final snapshot = await FirestoreService.fetchUsers();

    for (var doc in snapshot.docs) {
      _users.add(doc.data());
    }
    notifyListeners();
  }
  
 }

 Future<User> getUserData(String userId) async {
  for (User user in _users) {
    if (user.id == userId) {
      return user;
    }
  }

  final userDoc = await FirestoreService.getSingleUser(userId); 

  if (userDoc.exists) {
    final newUser = userDoc.data()!;
    _users.add(newUser);
    notifyListeners();
    
    return newUser; 
  } 
  else {
    return User(id: userId, name: 'Unknown User'); 
  }

  }

}