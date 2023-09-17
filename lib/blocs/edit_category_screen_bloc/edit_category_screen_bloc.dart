import 'dart:async';
import 'dart:developer';
import 'package:admin_ecommerce_app/blocs/edit_category_screen_bloc/edit_category_screen_event.dart';
import 'package:admin_ecommerce_app/blocs/edit_category_screen_bloc/edit_category_screen_state.dart';
import 'package:admin_ecommerce_app/repositories/category_repository.dart';
import 'package:admin_ecommerce_app/utils/image_picker_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCategoryScreenBloc
    extends Bloc<EditCategoryScreenEvent, EditCategoryScreenState> {
  EditCategoryScreenBloc()
      : super(const EditCategoryScreenInitial(imageSelected: null)) {
    on<LoadEditCategoryScreen>(_onLoadEditCategoryScreen);
    on<ChangeImage>(_onChangeImage);
    on<Update>(_onUpdate);
  }

  FutureOr<void> _onLoadEditCategoryScreen(LoadEditCategoryScreen event,
      Emitter<EditCategoryScreenState> emit) async {
    try {
      emit(const EditCategoryScreenLoading(imageSelected: null));
      final dio = Dio();
      final Uint8List image = (await dio.get(event.category.imgUrl,
              options: Options(responseType: ResponseType.bytes)))
          .data as Uint8List;
      emit(EditCategoryScreenLoaded(imageSelected: image));
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onChangeImage(
      ChangeImage event, Emitter<EditCategoryScreenState> emit) async {
    try {
      final image = await ImagePickerUtils.openFilePicker(event.context);
      emit(EditCategoryScreenLoaded(imageSelected: image));
    } catch (e) {
      log(e.toString());
    }
  }

  FutureOr<void> _onUpdate(
      Update event, Emitter<EditCategoryScreenState> emit) async {
    try {
      final currentState = state as EditCategoryScreenLoaded;
      emit(Updating(imageSelected: currentState.imageSelected));
      await CategoryRepository().updateCategory(
          image: currentState.imageSelected!, name: event.name, id: event.id);
      emit(UpdateSuccessful(imageSelected: currentState.imageSelected));
    } catch (e) {
      log(e.toString());
    }
  }
}
