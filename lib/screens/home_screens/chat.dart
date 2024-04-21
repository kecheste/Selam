import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/repository/chat.dart';
import 'package:buyme/repository/user.dart';
import 'package:buyme/screens/chat/chatroom.dart';
import 'package:buyme/screens/details_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user});

  final MyUser user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatRepository chatRepository = ChatRepository();
  final UserRepository userRepository = UserRepository();
  final AuthRepository authRepository = AuthRepository();

  Stream? chatRoomStream;
  Stream? favoriteStream;

  ontheload() async {
    chatRoomStream = await chatRepository.getChatRooms();
    favoriteStream = await userRepository.getFavoriteSenders();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  List<MyUser> favoritesReceivedList = [];

  getFavoriteListUsers() async {
    var favoriteReceivedDocument = await userRepository.usersCollection
        .doc(widget.user.id)
        .collection("favoritesRecieved")
        .get();
    for (int i = 0; i < favoriteReceivedDocument.docs.length; i++) {
      var favorite =
          await authRepository.getMyUser(favoriteReceivedDocument.docs[i].id);
      favoritesReceivedList.add(favorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 0,
          bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.pinkAccent,
              indicatorPadding:
                  EdgeInsets.only(left: 40, right: 40, top: 9, bottom: 9),
              indicator: ShapeDecoration(
                color: Colors.pinkAccent,
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
              tabs: const [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Messages",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Likes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                    stream: chatRoomStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> docs = snapshot.data!.docs;
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds = docs[index];
                            return ChatroomTile(
                                chatRoomId: ds.id,
                                dateSent: ds["dateSent"],
                                lastMessage: ds['lastMessage'],
                                user: widget.user);
                          },
                          itemCount: snapshot.data.docs.length,
                          shrinkWrap: true,
                        );
                      } else {
                        return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.pink.shade600,
                          size: 50,
                        ));
                      }
                    }),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                  stream: favoriteStream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> docs = snapshot.data!.docs;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = docs[index];
                          return FavoriteTile(
                              opponent: ds.id, user: widget.user);
                        },
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                      );
                    } else {
                      return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.pink.shade600,
                        size: 50,
                      ));
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ChatroomTile extends StatefulWidget {
  final String lastMessage, chatRoomId;
  final MyUser user;
  final Timestamp dateSent;
  const ChatroomTile(
      {super.key,
      required this.dateSent,
      required this.chatRoomId,
      required this.lastMessage,
      required this.user});

  @override
  State<ChatroomTile> createState() => _ChatroomTileState();
}

class _ChatroomTileState extends State<ChatroomTile> {
  final AuthRepository authRepository = AuthRepository();

  MyUser chatOponent = MyUser.empty;
  String username = "";

  getthisuserInfo() async {
    String opId =
        widget.chatRoomId.replaceAll("_", "").replaceAll(widget.user.id, "");
    MyUser chatUser = await authRepository.getMyUser(opId);
    setState(() {
      chatOponent = chatUser;
    });
  }

  @override
  void initState() {
    getthisuserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.pinkAccent.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.grey[850],
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatRoom(
                        user: widget.user,
                        chatOponent: chatOponent,
                        chatRoomId: widget.chatRoomId,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: chatOponent.photo == "" || chatOponent.photo == ""
                          ? Image.asset(
                              'assets/user1.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              chatOponent.photo!,
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                            ),
                    ),
                    chatOponent.id != ""
                        ? StreamBuilder(
                            stream: authRepository.usersCollection
                                .doc(chatOponent.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Positioned(
                                  top: 38,
                                  left: 38,
                                  child: Icon(
                                    Icons.circle,
                                    color: snapshot.data!['isOnline'] == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              } else {
                                return Positioned(
                                  top: 38,
                                  left: 38,
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.amber,
                                  ),
                                );
                              }
                            })
                        : Positioned(
                            top: 38,
                            left: 38,
                            child: Icon(
                              Icons.circle,
                              color: Colors.transparent,
                            ),
                          )
                  ]),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatOponent.name.length < 15
                            ? chatOponent.name
                            : "${chatOponent.name.substring(0, 10)}...",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.lastMessage.length < 10
                            ? widget.lastMessage
                            : "${widget.lastMessage.substring(0, 10)}...",
                        style: TextStyle(
                            fontSize: 17,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey.shade100),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                timeago.format(widget.dateSent.toDate()),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                    fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteTile extends StatefulWidget {
  final MyUser user;
  final String opponent;
  const FavoriteTile({
    super.key,
    required this.user,
    required this.opponent,
  });

  @override
  State<FavoriteTile> createState() => _FavoriteTileState();
}

class _FavoriteTileState extends State<FavoriteTile> {
  final AuthRepository authRepository = AuthRepository();

  MyUser liker = MyUser.empty;
  getthisuserInfo() async {
    MyUser likeUser = await authRepository.getMyUser(widget.opponent);
    setState(() {
      liker = likeUser;
    });
  }

  @override
  void initState() {
    getthisuserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.pinkAccent.shade100,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.grey[850],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsView(
                user: widget.user,
                opponent: liker,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: liker.photo == "" || liker.photo == ""
                          ? Image.asset(
                              'assets/user1.png',
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              liker.photo!,
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                    ),
                    liker.id != ""
                        ? StreamBuilder(
                            stream: authRepository.usersCollection
                                .doc(liker.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return Positioned(
                                  top: 30,
                                  left: 30,
                                  child: Icon(
                                    Icons.circle,
                                    size: 15,
                                    color: snapshot.data!['isOnline'] == true
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                );
                              } else {
                                return Positioned(
                                  top: 30,
                                  left: 30,
                                  child: Icon(
                                    Icons.circle,
                                    size: 15,
                                    color: Colors.red,
                                  ),
                                );
                              }
                            })
                        : Positioned(
                            top: 38,
                            left: 38,
                            child: Icon(
                              Icons.circle,
                              color: Colors.transparent,
                            ),
                          )
                  ]),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${liker.name} liked you.",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
