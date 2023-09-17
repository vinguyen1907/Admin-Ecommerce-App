import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

abstract class EditCategoryScreenState extends Equatable {
  final Uint8List? imageSelected;
  const EditCategoryScreenState({required this.imageSelected});
}

class EditCategoryScreenInitial extends EditCategoryScreenState {
  const EditCategoryScreenInitial({required super.imageSelected});

  @override
  List<Object> get props => [];
}

class EditCategoryScreenLoading extends EditCategoryScreenState {
  const EditCategoryScreenLoading({required super.imageSelected});

  @override
  List<Object> get props => [];
}

class EditCategoryScreenLoaded extends EditCategoryScreenState {
  const EditCategoryScreenLoaded({required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!];
}

class Updating extends EditCategoryScreenState {
  const Updating({required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!];
}

class UpdateSuccessful extends EditCategoryScreenState {
  const UpdateSuccessful({required super.imageSelected});

  @override
  List<Object> get props => [imageSelected!];
}
