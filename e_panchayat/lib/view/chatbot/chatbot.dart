import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // For JSON handling

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5B61B9),
      ),
      home: const ChatBotScreen(),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  List<dynamic> qnaData = []; // To store Q&A data

  @override
  void initState() {
    super.initState();
    _loadQnAData(); // Load Q&A data on initialization
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  Future<void> _loadQnAData() async {
    try {
      final String response = await rootBundle.loadString('assets/qen.json');
      setState(() {
        qnaData = json.decode(response);
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        messages.add({
          "text":
              "Oops! Something went wrong loading the data. Please check the assets or file.",
          "isUser": false,
        });
      });
    }
  }

  void sendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "isUser": true});
    });

    messageController.clear();
    _controller.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 400), () {
      String botResponse = _getResponse(text);
      setState(() {
        messages.add({"text": botResponse, "isUser": false});
      });
      _controller.forward(from: 0.0);

      Future.delayed(const Duration(milliseconds: 300), () {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String _getResponse(String userMessage) {
    String botResponse =
        "Sorry, I didn't understand that. Could you please rephrase?";

    for (var item in qnaData) {
      if (userMessage.toLowerCase().contains(item['question'].toLowerCase())) {
        botResponse = item['answer'];
        break;
      }
    }
    return botResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Prevent keyboard overlap
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 137, 123, 1),
                Color.fromRGBO(0, 204, 255, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          "ChatBot",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return SlideTransition(
                    position: _offsetAnimation,
                    child: Align(
                      alignment: message["isUser"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color: message["isUser"]
                              ? const Color.fromRGBO(0, 137, 123, 1)
                              : const Color(0xFFECEEF8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          message["text"],
                          style: TextStyle(
                            color: message["isUser"]
                                ? Colors.white
                                : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (qnaData.length >= 2)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: qnaData.take(2).map<Widget>((item) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            messageController.text = item['question'];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(130, 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          item['question'],
                          style: const TextStyle(fontSize: 14.0),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 380,
                  top: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        textInputAction: TextInputAction.send,
                        onSubmitted: sendMessage,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () => sendMessage(messageController.text),
                      backgroundColor: const Color.fromRGBO(0, 137, 123, 1),
                      elevation: 2,
                      mini: true,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
