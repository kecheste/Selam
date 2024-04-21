// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:typed_data';

import 'package:buyme/models/user_model.dart';
import 'package:buyme/repository/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    on<AuthEvent>((event, emit) {});

    on<CheckAuth>((event, emit) async {
      emit(AuthLoadingState());
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          MyUser myUser = await authRepository.getMyUser(user.uid);
          emit(AuthSuccessState(myUser));
        } else {
          emit(AuthLoggedOutState());
        }
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<GetMyUser>((event, emit) async {
      emit(AuthLoadingState());
      try {
        MyUser user = await authRepository.getMyUser(event.myUserId);
        emit(AuthSuccessState(user));
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<SendOtp>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await authRepository.sendOtp(
            phone: event.phone,
            errorStep: event.errorStep,
            nextStep: event.nextStep);
        emit(AuthOtpState());
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<SignInUser>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final MyUser user = await authRepository.loginWithOtp(
            otp: event.otp, phone: event.phone);
        emit(AuthSuccessState(user));
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });

    on<SignOutUser>((event, emit) async {
      emit(AuthLoadingState());
      try {
        authRepository.signOut();
        // ignore: empty_catches
        emit(AuthLoggedOutState());
      } catch (e) {
        emit(AuthFailureState(e.toString()));
      }
    });
  }
}
