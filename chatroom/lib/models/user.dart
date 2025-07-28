import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //Maybe profile pic later
  User({
    required this.name, required this.id, this.fcmToken,
    });

  final String name;
  final String id;
  final String? fcmToken;

  // user to firestore (map)
  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
      "fcmToken": fcmToken,
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
      fcmToken: data['fcmToken'],
    );

    return user;
  } 
}