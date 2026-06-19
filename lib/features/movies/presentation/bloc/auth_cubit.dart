import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      emit(AuthError("Fields cannot be empty!"));
      return;
    }

    emit(AuthLoading());

    // Mocking a network delay of 1.5 seconds to make it feel realistic
    await Future.delayed(const Duration(milliseconds: 1500));

    // Hardcoded mock credentials for testing
    if (username.trim() == 'admin' && password == '123') {
      emit(AuthSuccess(username));
    } else {
      emit(AuthError("Invalid username or password. (Try: admin / 123)"));
    }
  }

  void logout() {
    emit(AuthInitial());
  }
}