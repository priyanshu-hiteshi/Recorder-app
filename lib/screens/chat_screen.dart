import 'package:chatapp/models/messages_modal.dart';
import 'package:chatapp/screens/fetch-messages-helper/fetch_messages.dart';
import 'package:flutter/material.dart';
import '../helper/end_points.dart';
import '../models/messages_modal.dart'; // Import your Messages model

class ChatScreen extends StatefulWidget {
  final String userName;
  final int userId; // The userId of the current user

  const ChatScreen({super.key, required this.userName, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Messages> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await FetchMessages.fetchMessage();
      setState(() {
        _messages = response.map((e) => Messages.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching messages: $e");
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        // Add the new message to the message list
        _messages.add(Messages(
          id: DateTime.now().millisecondsSinceEpoch,
          content: _messageController.text,
          senderId: widget.userId,
          recipientId: null, // Update based on your logic
          roomId: null, // Update based on your logic
          senderInfo: SenderInfo(id: widget.userId, name: widget.userName, email: ""),
        ));
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        Messages message = _messages[index];
                        bool isCurrentUser = message.senderId == widget.userId;

                        return Align(
                          alignment: isCurrentUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 14.0),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.lightBlue[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            child: Text(
                              message.content,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
