part of 'employees_bloc.dart';

sealed class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

final class EmployeesInitial extends EmployeesState {}

final class EmployeesLoading extends EmployeesState {}

final class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;

  const EmployeesLoaded({required this.employees});

  @override
  List<Object> get props => [employees];
}

final class EmployeesError extends EmployeesState {
  final String message;

  const EmployeesError({required this.message});

  @override
  List<Object> get props => [message];
}
