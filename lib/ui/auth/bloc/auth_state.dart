part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  /* const AuthState(this.loginMode);

  final bool loginMode;*/

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  // const AuthInitial(bool loginMode) : super(loginMode);
  //const AuthInitial(super.loginMode);
}

class AuthLoading extends AuthState {
  //const AuthLoading(bool loginMode) : super(loginMode);
  //const AuthLoading(super.loginMode);
}

class AuthError extends AuthState {
  final AppException exception;

  AuthError(this.exception);
//const AuthError(super.loginMode, this.exception);
}

class AuthSuccess extends AuthState {
  //const AuthSuccess(bool loginMode) : super(loginMode);
  // AuthSuccess() : super(true);
  //const AuthSuccess(super.loginMode);
}
