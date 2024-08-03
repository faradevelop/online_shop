part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileStarted extends ProfileEvent {}

class UpdateProfileStarted extends ProfileEvent {
  final String name;
  final String? oldPass;
  final String? newPass;

  const UpdateProfileStarted(this.name, this.oldPass, this.newPass);
}
