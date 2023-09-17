import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_category_screen_event.dart';
part 'add_category_screen_state.dart';

class AddCategoryScreenBloc
    extends Bloc<AddCategoryScreenEvent, AddCategoryScreenState> {
  AddCategoryScreenBloc() : super(AddCategoryScreenInitial()) {
    on<LoadAddCategoryScreen>(_onLoadAddCategoryScreen);
    on<AddCategory>(_onAddCategory);
  }

  FutureOr<void> _onLoadAddCategoryScreen(
      LoadAddCategoryScreen event, Emitter<AddCategoryScreenState> emit) {
    emit(AddCategoryScreenLoaded());
  }

  FutureOr<void> _onAddCategory(
      AddCategory event, Emitter<AddCategoryScreenState> emit) async {
    emit(AddingCategory());
    try {
      await CategoryRepository()
          .addCategory(name: event.name, image: event.image);
      emit(AddSuccessful());
    } catch (e) {
      log(e.toString());
    }
  }
}
