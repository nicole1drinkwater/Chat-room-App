import 'package:chatroom/models/user.dart';
import 'package:chatroom/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//does automatic conversions
class FirestoreService {
  static final userRef = FirebaseFirestore.instance
  .collection("users")
  .withConverter(
    fromFirestore: User.fromFirestore,
    toFirestore: (User u, _) =>  u.toFireStore()
  );

  static final messageRef = FirebaseFirestore.instance
  .collection("messages")
  .withConverter(
    fromFirestore: Message.fromFirestore,
    toFirestore: (Message m, _) =>  m.toFireStore()
  );

  static Future<void> addUser(User user) async {
    await userRef.doc(user.id).set(user);
  }

  static Future<QuerySnapshot<User>> getUsersOnce() async {
    return userRef.get();
  }

  static Future<void> addMessage(Message message) async {
    await messageRef.doc(message.messageID).set(message);
  }

  static Future<QuerySnapshot<Message>> getMessagesOnce() async {
    return messageRef.get();
  }
 }