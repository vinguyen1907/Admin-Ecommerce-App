import 'package:admin_ecommerce_app/models/user.dart';
import 'package:admin_ecommerce_app/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  EmployeesBloc() : super(EmployeesInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<ReloadEmployees>(_onReloadEmployees);
  }

  _onLoadEmployees(LoadEmployees event, Emitter<EmployeesState> emit) async {
    try {
      emit(EmployeesLoading());
      final List<Employee> employees = await UserRepository().fetchEmployee();
      emit(EmployeesLoaded(employees: employees));
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }

  _onReloadEmployees(
      ReloadEmployees event, Emitter<EmployeesState> emit) async {
    try {
      final List<Employee> employees = await UserRepository().fetchEmployee();
      emit(EmployeesLoaded(employees: employees));
    } catch (e) {
      emit(EmployeesError(message: e.toString()));
    }
  }
}
