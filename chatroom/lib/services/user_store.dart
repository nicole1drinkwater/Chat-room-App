import 'package:flutter/material.dart';

import '../models/user.dart';

class UserStore extends ChangeNotifier {
  final List<User> _users = [
    User(id: '1', name: 'Nicole Drinkwater'),
    User(id: '2', name: 'Jane Doe'),
  ];
}