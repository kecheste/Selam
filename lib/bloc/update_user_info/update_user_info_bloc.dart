import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:buyme/repository/auth.dart';
import 'package:equatable/equatable.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc
    extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final AuthRepository authRepository;

  UpdateUserInfoBloc({required this.authRepository})
      : super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage = await authRepository.uploadPicture(
            event.file as Uint8List, event.userId);
        emit(UploadPictureSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });
  }
}
