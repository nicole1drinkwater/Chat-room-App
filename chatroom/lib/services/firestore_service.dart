import 'package:chatroom/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//does automatic conversions
class FirestoreService {
  static final ref = FirebaseFirestore.instance
  .collection("users")
  .withConverter(
    fromFirestore: User.fromFirestore,
    toFirestore: (User u, _) =>  u.toFireStore()
  );

  static Future<void> addUser(User user) async {
    await ref.doc(user.id).set(user);
  }
 }