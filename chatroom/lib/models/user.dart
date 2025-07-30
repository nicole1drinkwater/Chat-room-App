import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //Maybe profile pic later
  User({
    required this.name, required this.id, this.fcmToken, this.status = "offline", DateTime? lastSeen,
    }) : lastSeen = lastSeen ?? DateTime.now();

  final String name;
  final String id;
  final String? fcmToken;
  final String status;
  final DateTime lastSeen;

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

    final lastSeenTimestamp = data["lastSeen"] as Timestamp?;

    User user = User(
      name: data['name'],
      id: snapshot.id,
      fcmToken: data['fcmToken'],
      status: data['status'] ?? 'offline',
      lastSeen: lastSeenTimestamp?.toDate() ?? DateTime.now(),
    );

    return user;
  } 
}