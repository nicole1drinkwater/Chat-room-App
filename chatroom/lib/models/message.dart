import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.messageContent, required this.messageID, required this.senderID, required this.timeSent,
    });

  final String messageContent;
  final String messageID;
  final String senderID;
  final DateTime timeSent;

  // user to firestore (map)
  Map<String, dynamic> toFireStore() {
    return {
      "messageContent": messageContent,
      "senderID": senderID,
      "timeSent": FieldValue.serverTimestamp(),
    };
  }

  // user from firestore
  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    final timestamp = data['timeSent'] as Timestamp;

    Message message = Message(
      messageContent: data['messageContent'],
      senderID: data['senderID'],
      messageID: snapshot.id,
      timeSent: timestamp.toDate(),
    );

    print('content' + message.messageContent);

    return message;
  } 
}