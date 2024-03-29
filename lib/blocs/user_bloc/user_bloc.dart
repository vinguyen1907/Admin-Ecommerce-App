import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/repositories/user_repository.dart';
import 'package:admin_ecommerce_app/services/call_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }
  _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final UserModel? user = await UserRepository().getUser();
      if (user == null) {
        throw Exception("User not found");
      }
      if (!kIsWeb) {
        await CallService().initCallService();
      }
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
