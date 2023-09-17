import 'package:admin_ecommerce_app/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class EditCategoryScreenEvent extends Equatable {
  const EditCategoryScreenEvent();
}

class LoadEditCategoryScreen extends EditCategoryScreenEvent {
  final Category category;
  const LoadEditCategoryScreen({required this.category});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChangeImage extends EditCategoryScreenEvent {
  final BuildContext context;
  const ChangeImage({
    required this.context,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Update extends EditCategoryScreenEvent {
  final String name;
  final String id;
  const Update({required this.name, required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
