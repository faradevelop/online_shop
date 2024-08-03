import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final IAuthRepository authRepository;

  AuthBloc(
    this.authRepository,
  ) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      try {
        if (event is LoginButtonIsClicked) {
          emit(AuthLoading());
          await authRepository.login(
            event.mobile,
            event.password,
          );
          emit(AuthSuccess());
        } else if (event is RegisterButtonIsClicked) {
          emit(AuthLoading());
          await authRepository.register(
            event.name,
            event.mobile,
            event.password,
            event.passwordConfirmation,
          );
          emit(AuthSuccess());
        } else if (event is AuthModeChangeIsClicked) {
          //change
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthError( AppException()));
      }
    });
  }
}
/* bool loginMode;*/
// loginMode = !loginMode;