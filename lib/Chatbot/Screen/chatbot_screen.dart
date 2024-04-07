import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/CustomTheme.dart';

class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
        ),
        title: Center(
          child: Text(
            "O3 Help",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelLarge,
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
      body: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController _textController = TextEditingController();
  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              return _messages[index];
            },
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    // Change this line for grey background
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.pinkAccent,
                ),
                onPressed: () {
                  _sendMessage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: _textController.text,
          sender: MessageSender.user,
        ));
        // Simulating bot response
        style:
        GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.labelLarge,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        );
        _messages.add(ChatMessage(
          text: 'Yes, sir',
          sender: MessageSender.bot,
        ));
        _textController.clear();
      });
    }
  }
}

enum MessageSender {
  user,
  bot,
}

class ChatMessage extends StatelessWidget {
  final String text;
  final MessageSender sender;

  const ChatMessage({
    required this.text,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sender == MessageSender.user
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: sender == MessageSender.user
              ? Colors.pinkAccent
              : Colors.red[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.labelLarge,
            fontSize: 14,
            color: sender == MessageSender.user ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}
