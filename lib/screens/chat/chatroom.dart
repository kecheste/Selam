import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/repository/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom(
      {super.key,
      required this.user,
      required this.chatRoomId,
      required this.chatOponent});

  final MyUser user;
  final MyUser chatOponent;
  final String chatRoomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final ChatRepository chatRepository = ChatRepository();

  String myId = FirebaseAuth.instance.currentUser!.uid;

  Stream? messageStream;

  Future addMessage(String text) async {
    if (_messageController.text != "") {
      Map<String, dynamic> messageInfoMap = {
        "message": text,
        "sentBy": widget.user.id,
        "sentDate": Timestamp.now()
      };

      chatRepository
          .sendMessage(widget.chatRoomId, messageInfoMap, widget.chatOponent.id)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": text,
          "dateSent": DateTime.now(),
          "sentBy": widget.user.id
        };
        chatRepository.updateLastMessageSent(
            widget.chatRoomId, lastMessageInfoMap);
      });
    }
  }

  Widget chatMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMessageTile(
                        ds["message"], widget.user.id == ds['sentBy']);
                  })
              : Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.pink.shade600,
                  size: 50,
                ));
        });
  }

  getAndSetMessage() async {
    messageStream = await chatRepository.getChatMessages(widget.chatRoomId);
    setState(() {});
  }

  ontheload() async {
    await getAndSetMessage();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  Widget chatMessageTile(String message, bool sentByMe) {
    return Align(
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin:
              EdgeInsets.only(bottom: 10, right: sentByMe ? 10 : 0, left: 10),
          decoration: BoxDecoration(
            color: sentByMe ? Colors.pinkAccent : Colors.grey[850],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(12),
              bottomLeft: sentByMe ? Radius.circular(12) : Radius.circular(0),
              bottomRight: sentByMe ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.chatOponent.name),
            SizedBox(
              width: 5,
            ),
            SizedBox(
              child: StreamBuilder(
                  stream: authRepository.usersCollection
                      .doc(widget.chatOponent.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                        Icons.circle,
                        size: 15,
                        color: snapshot.data!['isOnline'] == true
                            ? Colors.green
                            : Colors.red,
                      );
                    } else {
                      return Icon(
                        Icons.circle,
                        size: 15,
                        color: Colors.amber,
                      );
                    }
                  }),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: chatMessage(),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: SizedBox(
                  child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _messageController,
                onSubmitted: (text) {
                  if (text != "" || text != " ") {
                    addMessage(text);
                    _messageController.clear();
                  }
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pinkAccent),
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.pinkAccent,
                        )),
                    focusColor: Colors.pinkAccent,
                    fillColor: Colors.grey.shade800,
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (_messageController.text != "" ||
                              _messageController.text != " ") {
                            addMessage(_messageController.text);
                            _messageController.clear();
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Colors.pinkAccent,
                        )),
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Colors.white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 4)),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
