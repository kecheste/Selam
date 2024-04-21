import 'package:bloc/bloc.dart';
import 'package:buyme/repository/user.dart';
import 'package:equatable/equatable.dart';

part 'matches_event.dart';
part 'matches_state.dart';

class MatchesBloc extends Bloc<MatchesEvent, MatchesState> {
  final UserRepository userRepository;

  MatchesBloc({required this.userRepository}) : super(MatchesInitial()) {
    on<MatchesEvent>((event, emit) {});

    on<GetMatches>((event, emit) async {
      emit(MatchLoadingState());
      try {
        final List matches = await userRepository.getMatches();
        emit(MatchSuccessState(matches));
      } catch (e) {
        emit(MatchFailedState(e.toString()));
      }
    });

    on<GetMatchesByLocation>((event, emit) async {
      emit(MatchLoadingState());
      try {
        final List matches = await userRepository.getMatchesByLocation();
        emit(MatchSuccessState(matches));
      } catch (e) {
        emit(MatchFailedState(e.toString()));
      }
    });
  }
}
