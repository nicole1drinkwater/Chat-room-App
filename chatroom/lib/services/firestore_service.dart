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

  static Future<QuerySnapshot<User>> fetchUsers() async {
    return userRef.get();
  }

  static Future<DocumentSnapshot<User>> getSingleUser(String userId) async {
  return userRef.doc(userId).get();
  }

  static Future<void> addMessage(Message message) async {
    await messageRef.add(message);
  }

  static Stream<QuerySnapshot<Message>> getMessagesStream() {
    return messageRef.orderBy("timeSent").snapshots();
  }
  
  static Future<void> updateUserStatus(String userId, String status) async {
     try {
      await userRef.doc(userId).update({
        'status': status,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        print('User document not found for status update, ignoring: $userId');
      } else {
        print('An error occurred while updating user status: $e');
        rethrow;
      }
    } catch (e) {
      print('An unhandled error occurred during status update: $e');
    }
  }

  static Stream<QuerySnapshot<User>> getUsersStream() {
    return userRef.snapshots();
  }
 }