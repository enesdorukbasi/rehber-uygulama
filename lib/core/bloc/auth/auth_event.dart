part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {
  final BuildContext context;

  const AppStarted(this.context);

  @override
  List<Object> get props => [context];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final BuildContext context;

  const LoginEvent(this.email, this.password, this.context);

  @override
  List<Object> get props => [email, password, context];
}
