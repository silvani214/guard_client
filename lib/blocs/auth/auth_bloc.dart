import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final AuthService authService;

  AuthBloc({required this.authRepository, required this.authService})
      : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.username, event.password);
        if (user != null) {
          emit(AuthSuccess(user: user));
        } else {
          emit(AuthFailure(error: 'Login failed'));
        }
      } catch (e) {
        emit(AuthFailure(error: 'Login failed'));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await authRepository.signUp(
            event.email, event.password, event.firstName, event.lastName);
        if (result! == true) {
          emit(AuthSignUp());
        } else {
          emit(AuthFailure(error: 'Sign up failed'));
        }
      } catch (e) {
        emit(AuthFailure(error: 'Sign up failed'));
      }
    });

    on<CheckAuthEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.me();
        if (user != null) {
          emit(AuthChecked(isAuthenticated: true));
        } else {
          emit(AuthChecked(isAuthenticated: false));
        }
      } catch (e) {
        emit(AuthChecked(isAuthenticated: false));
      }
    });
  }
}
