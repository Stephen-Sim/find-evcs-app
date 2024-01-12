import 'package:find_evcs/blocs/admin/login/login_event.dart';
import 'package:find_evcs/blocs/admin/login/login_state.dart';
import 'package:find_evcs/repositories/admin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AdminRepository repo;

  LoginBloc(LoginState LoginInitial, this.repo) : super(LoginInitial) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final bool success = await repo.login(event.username, event.password);
        if (success) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure('Login failed'));
        }
      } catch (error) {
        emit(LoginFailure(error.toString()));
      }
    });
  }
}
