import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String text;
  final String senderId;
  final String senderProfileUrl;
  final String senderName;
  final String messageId;
  final bool sent;
  final bool unsent;
  final bool active;
  final DateTime time;
  MessageModel(this.text, this.senderId, this.senderProfileUrl, this.senderName, this.messageId, this.sent,this.unsent, this.active, this.time);
  factory  MessageModel.formSnap(Map<String, dynamic> snapshot) {
       return MessageModel(
        snapshot['text'] ?? '',
        snapshot['senderid'] ?? '',
        snapshot['senderprofileurl'] ?? '',
        snapshot['sendername'] ?? '',
        snapshot['messageid'] ?? '',
        snapshot['sent'] ?? false,
        snapshot['unsent'] ?? false,
        snapshot['active'] ?? false,
        (snapshot['time'] as Timestamp).toDate() ,
       );
   
  }
}
