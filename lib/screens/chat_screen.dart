import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

final _store = FirebaseFirestore.instance;
late User currentUser;

class ChatScreen extends StatefulWidget {

  static const String id = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  late String messageText;

  void getCurrentUser()  {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(user.email);
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _store.collection('messages').add({'sender': currentUser.email, 'text': messageText, 'timestamp': FieldValue.serverTimestamp()});
                      setState(() {
                        messageTextController.clear();
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection('messages').orderBy('timestamp').snapshots(),
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


class MessageBubble extends StatelessWidget {

  const MessageBubble({required this.text, required this.sender, required this.fromUser});

  final String text;
  final String sender;
  final bool fromUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
            ),
          ),
          Material(
            borderRadius: fromUser ? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))
            : BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: fromUser ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 18.0,
                  color: fromUser ? Colors.white : Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
