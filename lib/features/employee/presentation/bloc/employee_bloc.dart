import 'package:bloc/bloc.dart';
import 'package:employee_data_app/core/shared/services/storage_services.dart';
import 'package:employee_data_app/features/employee/entity/employee_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_event.dart';
part 'employee_state.dart';
part 'employee_bloc.freezed.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final StorageService storageService;
  EmployeeBloc(this.storageService) : super(const EmployeeState()) {
    on<_OpenEmployeeDB>((event, emit) async {
      final employees = await storageService.openEmployeeDB();
      emit(state.copyWith(employess: employees));
    });
    on<_AddEmployee>((event, emit) async {
      final employees = await storageService.addEmployee(event.model);
      emit(state.copyWith(employess: employees));
    });
    on<_UpdateEmployee>((event, emit) async {
      final employees = await storageService.updateEmployee(event.index, event.model);
      emit(state.copyWith(employess: employees));
    });
    on<_DeleteEmployee>((event, emit) async {
      final employees = await storageService.deleteEmployee(event.index);
      emit(state.copyWith(employess: employees));
    });
  }
}
