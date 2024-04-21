// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/chat.dart';
import 'package:buyme/repository/user.dart';
import 'package:buyme/screens/chat/chatroom.dart';
import 'package:buyme/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.user, required this.opponent});

  final MyUser user;
  final MyUser opponent;

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final UserRepository userRepository = UserRepository();
  final ChatRepository chatRepository = ChatRepository();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: double.infinity,
          ),
          Image.network(
            widget.opponent.photo!,
            height: MediaQuery.sizeOf(context).height * 0.7,
            width: MediaQuery.sizeOf(context).width,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 20,
            top: 250,
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(70, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                      onPressed: () async {
                        var chatRoomId = getChatRoomIdByUsername(
                            widget.opponent.id, widget.user.id);

                        Map<String, dynamic> chatRoomInfoMap = {
                          "users": [widget.opponent.id, widget.user.id]
                        };
                        await chatRepository.createChatRoom(
                            chatRoomId, chatRoomInfoMap);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                    user: widget.user,
                                    chatOponent: widget.opponent,
                                    chatRoomId: chatRoomId)));
                      },
                      icon: Icon(
                        Icons.message_outlined,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(70, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    onPressed: () async {
                      await userRepository.sendFavorite(widget.opponent.id);
                    },
                    icon: Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "${widget.opponent.name.split(" ")[0]}, ${widget.opponent.age}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(30)),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              )
            ],
          ),
          Positioned.fill(
            top: 450,
            child: SingleChildScrollView(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.mic,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                widget.opponent.bio.toString(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Current location",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.opponent.location!,
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "${widget.opponent.name.split(" ")[0]}'s interests",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          spacing: 10,
                          children: [
                            for (String interest
                                in widget.opponent.interestedIn!)
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 10,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.pink,
                                ),
                                child: Text(
                                  interest,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
