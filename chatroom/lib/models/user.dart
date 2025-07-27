import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //Maybe profile pic later
  User({
    required this.name, required this.id,
    });

  final String name;
  final String id;

  // user to firestore (map)
  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
    };
  }

  // user from firestore
  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    User user = User(
      name: data['name'],
      id: snapshot.id,
    );

    return user;
  } 
}