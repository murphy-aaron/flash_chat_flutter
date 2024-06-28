import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/message_bubble.dart';

class MessagesStream extends StatelessWidget {

  const MessagesStream({required this.currentUser, required this.store});

  final User currentUser;
  final FirebaseFirestore store;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: store.collection('messages').orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MessageBubble> messageBubbles = [];
            final messages = snapshot.data!.docs.reversed;
            for (var message in messages) {
              final messageText = message['text'];
              final messageSender = message['sender'];
              final messageWidget = MessageBubble(text: messageText, sender: messageSender, fromUser: messageSender == currentUser.email);
              messageBubbles.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                children: messageBubbles,
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.lightBlueAccent,
              ),
            );
          }
        }
    );
  }
}