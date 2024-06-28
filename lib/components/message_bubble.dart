import 'package:flutter/material.dart';

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
