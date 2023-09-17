part of 'add_category_screen_bloc.dart';

abstract class AddCategoryScreenEvent extends Equatable {
  const AddCategoryScreenEvent();
}

class LoadAddCategoryScreen extends AddCategoryScreenEvent {
  const LoadAddCategoryScreen();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddCategory extends AddCategoryScreenEvent {
  const AddCategory(this.image, this.name);
  final Uint8List image;
  final String name;
  @override
  // TODO: implement props
  List<Object?> get props => [image, name];
}
