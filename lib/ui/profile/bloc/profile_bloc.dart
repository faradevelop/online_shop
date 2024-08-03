import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/user.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IProfileRepository profileRepository;
  final IAuthRepository authRepository;


  ProfileBloc(this.profileRepository, this.authRepository) : super(Loading()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ProfileStarted) {
        emit(Loading());
        try {
          final user = await profileRepository.getProfile();

          emit(ProfileSuccess(user));
        } catch (e) {
          emit(ProfileError(exception: e is AppException ? e : AppException()));
        }
      } else if (event is UpdateProfileStarted) {
        emit(Loading());
        try {
          await authRepository.editProfile(
              name: event.name,
              oldPassword: event.oldPass,
              newPassword: event.newPass);

          emit(UpdateProfileSuccess());
        } catch (e) {
          emit(UpdateProfileError(
              exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
