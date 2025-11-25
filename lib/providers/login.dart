import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class LoginState {
  final String email;
  final String password;
  final bool isLoading;

  LoginState({this.email = '', this.password = '', this.isLoading = false});

  LoginState copyWith({String? email, String? password, bool? isLoading}) {
    return LoginState(email: email ?? this.email, password: password ?? this.password, isLoading: isLoading ?? this.isLoading);
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref) : super(LoginState());
  final Ref ref;

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }

  Future<void> login() async {
    if (state.email.isEmpty || state.password.isEmpty) return;

    state = state.copyWith(isLoading: true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(isLoading: false);

    // Navigate to dashboard

    //context.go(AppRoute.dashboard.path);
    //}
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier(ref);
});
