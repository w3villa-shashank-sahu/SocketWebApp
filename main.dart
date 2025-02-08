import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late io.Socket userChatSocket;
  late io.Socket botChatSocket;

  final TextEditingController _userMessageController = TextEditingController();
  final TextEditingController _botMessageController = TextEditingController();

  List<Map<String, String>> userMessages = [];
  List<Map<String, String>> botMessages = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    userChatSocket = io.io('ws://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    botChatSocket.onConnect((_) {
      debugPrint("Connected to AI Chat Server");
    });

    userChatSocket.onConnect((_) {
      debugPrint("Connected to User Chat Server");
    });

    userChatSocket.on("receive_message", (data) {
      setState(() {
        userMessages.add({"message": data["message"], "sender": data["sender"]});
      });
    });

    botChatSocket = io.io('ws://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    botChatSocket.on("bot-receive_message", (data) {
      setState(() {
        botMessages.add({"message": data["message"], "sender": "AI"});
      });
    });
  }

  void sendMessageToUser(String message) {
    if (message.isNotEmpty) {
      setState(() {
        userMessages.add({"message": message, "sender": "You"});
      });
      userChatSocket.emit("user_send_message", {"message": message});
      _userMessageController.clear();
    }
  }

  void sendMessageToBot(String message) {
    if (message.isNotEmpty) {
      setState(() {
        botMessages.add({"message": message, "sender": "You"});
      });

      botChatSocket.emit("bot_send_message", {"message": message});
      _botMessageController.clear();
    }
  }

  @override
  void dispose() {
    userChatSocket.dispose();
    botChatSocket.dispose();
    _tabController.dispose();
    _userMessageController.dispose();
    _botMessageController.dispose();
    super.dispose();
  }

  Widget buildChatUI(List<Map<String, String>> messages, TextEditingController controller, Function(String) onSend) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]["sender"] == "You";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      messages[index]["message"]!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onSubmitted: (value) => onSend(value),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => onSend(controller.text),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            Text("Talkie", style: TextStyle(color: Colors.purple.shade100, fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.deepPurple,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple.shade100,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.purple.shade100,
          tabs: [
            Tab(text: "Global Chat"),
            Tab(text: "AI Chat"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildChatUI(userMessages, _userMessageController, sendMessageToUser),
          buildChatUI(botMessages, _botMessageController, sendMessageToBot),
        ],
      ),
    );
  }
}
