part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class Loading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserEntity user;

  const ProfileSuccess(this.user);
}

final class ProfileError extends ProfileState {
  final AppException exception;

  const ProfileError({required this.exception});

  @override
  List<Object> get props => [exception];
}

final class UpdateProfileSuccess extends ProfileState {}

final class UpdateProfileError extends ProfileState {
  final AppException exception;

  const UpdateProfileError({required this.exception});

  @override
  List<Object> get props => [exception];
}
