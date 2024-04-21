import 'package:buyme/bloc/matches/matches_bloc.dart';
import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:buyme/screens/details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({super.key, required this.user});

  final MyUser user;

  @override
  State<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MatchesBloc>().add(GetMatchesByLocation());
  }

  final AuthRepository authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchSuccessState) {
          return Container(
            color: Colors.grey.shade900,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.sizeOf(context).width * 0.5,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemCount: state.matches.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailsView(
                              user: widget.user,
                              opponent: state.matches[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.45,
                                height: MediaQuery.sizeOf(context).width * 0.55,
                                child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    fit: StackFit.expand,
                                    children: [
                                      state.matches[index].photo != "" ||
                                              state.matches[index].photo != " "
                                          ? Image.network(
                                              state.matches[index].photo,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/2.jpg',
                                              fit: BoxFit.cover,
                                            ),
                                      Positioned(
                                          left: 10,
                                          bottom: 12,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              StreamBuilder(
                                                  stream: authRepository
                                                      .usersCollection
                                                      .doc(state
                                                          .matches[index].id)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data != null) {
                                                      return Row(
                                                        children: [
                                                          Text(
                                                            '${state.matches[index].name.split(" ")[0]}, ${state.matches[index].age}',
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Icon(
                                                            Icons.circle,
                                                            size: 15,
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
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Icon(
                                                            Icons.circle,
                                                            size: 15,
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  }),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  Text(
                                                    state.matches[index]
                                                        .location!
                                                        .split(',')[0],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  )
                                                ],
                                              )
                                            ],
                                          ))
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }
        return Center(
            child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.pink.shade600,
            size: 50,
          ),
        ));
      },
    );
  }
}
