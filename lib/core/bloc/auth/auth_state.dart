part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, authenticating }

class AuthState {
  final AuthStatus status;
  final String? error;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.error,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated()
      : this._(
          status: AuthStatus.authenticated,
        );

  const AuthState.authenticating()
      : this._(
          status: AuthStatus.authenticating,
        );

  AuthState.error({String error = "Bir hata oluştu."})
      : this._(status: AuthStatus.unknown, error: error);
}
