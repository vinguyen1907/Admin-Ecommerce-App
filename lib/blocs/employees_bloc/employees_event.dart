part of 'employees_bloc.dart';

sealed class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeesEvent {}

class ReloadEmployees extends EmployeesEvent {}
