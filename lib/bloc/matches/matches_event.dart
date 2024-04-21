part of 'matches_bloc.dart';

abstract class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class GetMatches extends MatchesEvent {
  const GetMatches();
}

class GetMatchesByLocation extends MatchesEvent {
  const GetMatchesByLocation();
}

class CheckMatches extends MatchesEvent {
  const CheckMatches();
}
