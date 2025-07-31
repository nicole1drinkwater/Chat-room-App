import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.messageContent, required this.messageID, required this.senderID, required this.timeSent, this.imageUrl,
    required this.messageType,
    });

  final String messageContent;
  final String messageID;
  final String senderID;
  final DateTime timeSent;
  final String? imageUrl;
  final String messageType;

  // user to firestore (map)
  Map<String, dynamic> toFireStore() {
    return {
      "messageContent": messageContent,
      "senderID": senderID,
      "timeSent": FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
      "messageType": messageType,
    };
  }

  // user from firestore
  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    final timestamp = data['timeSent'] as Timestamp?;

    Message message = Message(
      messageContent: data['messageContent'],
      senderID: data['senderID'],
      messageID: snapshot.id,
      timeSent: timestamp?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl'],
      messageType: data['messageType'] ?? 'text',
    );
    
    return message;
  } 
}