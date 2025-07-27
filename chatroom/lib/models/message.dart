class Message {
  Message({
    required this.messageContent, required this.messageID, required this.senderID, required this.timeSent,
    });

  final String messageContent;
  final String messageID;
  final String senderID;
  final DateTime timeSent;
}