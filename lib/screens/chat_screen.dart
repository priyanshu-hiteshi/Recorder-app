import 'package:chatapp/models/messages_modal.dart';
import 'package:chatapp/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final int userId; // The userId of the current user

  const ChatScreen({super.key, required this.userName, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MessageProvider>().fetchMessages(userId: widget.userId);
  }

  // void _sendMessage() async {
  //   if (_messageController.text.isNotEmpty) {
  //     try {
  //       // Show a local message first
  //       var senderInfo = SenderInfo(
  //         id: 10,
  //         name: widget.userName,
  //         email: "", // Add email if available
  //       );
  //       setState(() {
  //         _messages.add(Messages(
  //             id: DateTime.now().millisecondsSinceEpoch, // Temporary local ID
  //             content: _messageController.text,
  //             senderId: 10,
  //             recipientId:
  //                 widget.userId, // This can be adjusted based on your logic
  //             // roomId: null,
  //             senderInfo: senderInfo));
  //       });

  //       // Call the SendMessageService to send the message to the backend
  //       final response = await SendMessagesService.sendMessage(
  //         messageModel: MessageModel(
  //             senderId: 10.toString(),
  //             recipientId: widget.userId.toString(),
  //             content: _messageController.text,
  //             senderInfo: senderInfo),
  //       );

  //       // Add the actual response message returned from the backend
  //       setState(() {
  //         _messages[_messages.length - 1] = Messages(
  //           id: response['id'], // Actual ID returned by the server
  //           content: response['content'],
  //           senderId: response['sender_id'],
  //           recipientId: response['recipient_id'],
  //           // roomId: response['room_id'],
  //           senderInfo: SenderInfo(
  //             id: int.parse(response['sender_info']['id']),
  //             name: response['sender_info']['name'],
  //             email: response['sender_info']['email'],
  //           ),
  //         );
  //         _messageController.clear();
  //       });
  //     } catch (e) {
  //       print("Error sending message: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to send message")),
  //       );
  //     }
  //   }
  // }

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
          Expanded(child: Consumer<MessageProvider>(
            builder: (context, value, child) {
              var _isLoading = value.isLoading;
              var _messages = value.messages;
              return _isLoading
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
                          bool isCurrentUser =
                              message.senderId == widget.userId;

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
                    );
            },
          )),
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
                    onPressed: () {},
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
