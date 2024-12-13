import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({super.key, required this.userName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _connectToSocket();
  }

  void _connectToSocket() {
   
    socket = IO.io('http://192.168.100.126:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    
    socket.connect();
      
   

   
    socket.on('chat_message', (data) {
      setState(() {
        _messages.add(data);
      });
    });

   
    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text.trim();

     
      socket.emit('chat_message', message);

      setState(() {
        _messages
            .add(message); // Add message to local list for immediate display
        _messageController.clear(); // Clear input field
      });
    }
  }

  @override
  void dispose() {
    socket.dispose(); // Dispose of socket connection when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.userName}'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                  String message = _messages[index];

                  // Split the message at 10 characters
                  String firstLine =
                      message.length > 10 ? message.substring(0, 10) : message;
                  String remainingMessage =
                      message.length > 10 ? message.substring(10) : '';

                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 14.0),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue[100], // Light blue background
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.75, // Limit message width
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // First line (up to 10 characters)
                          Text(
                            firstLine,
                            style: TextStyle(color: Colors.black87),
                            overflow: TextOverflow
                                .ellipsis, // Handles overflow in the first line
                          ),
                          // Remaining message (next lines)
                          if (remainingMessage.isNotEmpty)
                            Text(
                              remainingMessage,
                              style: TextStyle(color: Colors.black87),
                            ),
                        ],
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
