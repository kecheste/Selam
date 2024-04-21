// ignore_for_file: use_build_context_synchronously

import 'package:buyme/bloc/matches/matches_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/repository/chat.dart';
import 'package:buyme/repository/user.dart';
import 'package:buyme/screens/chat/chatroom.dart';
import 'package:buyme/service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key, required this.user});

  final MyUser user;

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final ChatRepository chatRepository = ChatRepository();
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    context.read<MatchesBloc>().add(GetMatches());
  }

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();

    return Container(
      color: Colors.grey.shade900,
      child: BlocBuilder<MatchesBloc, MatchesState>(
        builder: (context, state) {
          if (state is MatchLoadingState) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.pink.shade600,
                size: 50,
              ),
            );
          } else if (state is MatchSuccessState) {
            if (state.matches.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/exclamation.png",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "No matches found!",
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              );
            }
            final List matches = state.matches;
            return Swiper(
              itemCount: matches.length,
              layout: SwiperLayout.TINDER,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height,
              loop: true,
              duration: 600,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        fit: StackFit.expand,
                        children: [
                          matches[index].photo == "" ||
                                  matches[index].photo == " "
                              ? Image.asset(
                                  'assets/user.jpg',
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.9,
                                )
                              : Image.network(
                                  matches[index].photo!,
                                  fit: BoxFit.cover,
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.9,
                                ),
                          Positioned(
                            right: 20,
                            bottom: 80,
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          70, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () async {
                                        var chatRoomId =
                                            getChatRoomIdByUsername(
                                                matches[index].id,
                                                widget.user.id);

                                        Map<String, dynamic> chatRoomInfoMap = {
                                          "users": [
                                            matches[index].id,
                                            widget.user.id
                                          ]
                                        };
                                        await chatRepository.createChatRoom(
                                            chatRoomId, chatRoomInfoMap);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ChatRoom(
                                                    user: widget.user,
                                                    chatOponent: matches[index],
                                                    chatRoomId: chatRoomId)));
                                      },
                                      icon: Icon(
                                        Icons.message_outlined,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          70, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: IconButton(
                                      onPressed: () async {
                                        await userRepository
                                            .sendFavorite(matches[index].id);
                                      },
                                      icon: Icon(
                                        Icons.favorite_outline,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              left: 30,
                              bottom: 30,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder(
                                      stream: authRepository.usersCollection
                                          .doc(state.matches[index].id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          return Row(
                                            children: [
                                              Text(
                                                '${state.matches[index].name.split(" ")[0]}, ${state.matches[index].age}',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.circle,
                                                size: 20,
                                                color: snapshot.data![
                                                            'isOnline'] ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            children: [
                                              Text(
                                                '${state.matches[index].name.split(" ")[0]}, ${state.matches[index].age}',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.circle,
                                                color: Colors.redAccent,
                                              ),
                                            ],
                                          );
                                        }
                                      }),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                        state.matches[index].location!
                                                .split(',')[0] ??
                                            'Unknown',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is MatchFailedState) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
