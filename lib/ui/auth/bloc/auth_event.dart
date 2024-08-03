part of 'auth_bloc.dart';

@immutable
 sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class LoginButtonIsClicked extends AuthEvent {

  final String mobile;
  final String password;

  const LoginButtonIsClicked(

      this.mobile,
      this.password,
      );
}

class RegisterButtonIsClicked extends AuthEvent {
  final String name;
  final String mobile;
  final String password;
  final String passwordConfirmation;

  const RegisterButtonIsClicked(
    this.name,
    this.mobile,
    this.password,
    this.passwordConfirmation,
  );
}

class AuthModeChangeIsClicked extends AuthEvent {}
