abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String username;
  AuthSuccess(this.username);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}