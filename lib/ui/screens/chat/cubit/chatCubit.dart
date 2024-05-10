import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterquiz/features/battleRoom/models/message.dart';
import 'package:flutterquiz/ui/screens/chat/model/messageModel.dart';

abstract class ChatState {

}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<MessageModel> messageList;

  ChatLoadedState({required this.messageList});
  List<MessageModel> get getList => messageList;
}

class ChatCubit extends Cubit<List<MessageModel>> {
  final int messageLimit = 40;
  late StreamSubscription<List<MessageModel>> _messagesStream;
  final chatCollection = FirebaseFirestore.instance.collection('chat');
  final _messageController = StreamController<List<MessageModel>>.broadcast();
  Stream<List<MessageModel>> get messageStream => _messageController.stream;
  ChatCubit() : super([]) {
    _initChat();
  }

  void unsentMessage(String messageId) {
    try {
      chatCollection.doc(messageId).update({
        'unsent': true,
      });
    } catch (e) {
      chatCollection.doc(messageId).update({
        'unsent': true,
      });
    }
  }

  Future<void> sendMessage({required MessageModel messageModel}) async {
    late DocumentReference chatReference;
    try {
      chatReference = await FirebaseFirestore.instance.collection('chat').add({
        "text": messageModel.text,
        "senderid": messageModel.senderId,
        "senderprofileurl": messageModel.senderProfileUrl,
        "sendername": messageModel.senderName,
        "messageid": messageModel.messageId,
        "sent": messageModel.sent,
        "unsent": messageModel.sent,
        "active": messageModel.active,
        "time": messageModel.time,
      });

      await chatReference.update({
        "messageid": chatReference.id,
        "sent": true,
      });

      print("Message sent successfully");
    } catch (error, stackTrace) {
      print("Error sending message: $error");
      print("Stack trace: $stackTrace");

      // Handle the error and update the isSent field to false
      await chatReference.update({
        "messageid": chatReference.id,
        "sent": false,
      });

      print("Message not sent");
      // You can handle the error or update UI accordingly
    }
  }

  _initChat() {
    _messagesStream = chatCollection
        .orderBy('time', descending: true)
        .limit(messageLimit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => MessageModel.formSnap(
                  doc.data(),
                ),
              )
              .toList(),
        )
        .listen((newMessages) {
      emit(newMessages);
    });
  }

  void fetchMoreMessages() async {
    final lastMessage = state.isNotEmpty ? state.last : null;
    if (lastMessage != null) {
      try {
        final additionalMessages = await chatCollection
            .orderBy('time', descending: true)
            .startAfter([lastMessage.time])
            .limit(messageLimit)
            .get()
            .then((snapshot) => snapshot.docs
                .map((doc) => MessageModel.formSnap(doc.data()))
                .toList());

        // Combine existing messages with additional messages
        final newState = [...state, ...additionalMessages];

        // Emit the combined state
        emit(newState);
      } catch (e) {
        print("Error fetching more messages: $e");
      }
    }
  }



}




