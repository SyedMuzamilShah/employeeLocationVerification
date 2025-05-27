import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_filter_enum_entities.dart';

final employeeUpdateProvider = StateNotifierProvider.autoDispose<EmployeeUpdateNotifier, EmployeeUpdateParams>((ref){
  return EmployeeUpdateNotifier();
});

class EmployeeUpdateNotifier extends StateNotifier<EmployeeUpdateParams> {
  EmployeeUpdateNotifier(): super(EmployeeUpdateParams(id: ''));

  employeeId (String id) {
    state = state.copyWith(id: id);
  }

  employeeStateChnage (EmployeeStatus status) {
    state = state.copyWith(status: status);
  }

  employeeRoleChange(EmployeeRole role) {
    state = state.copyWith(role: role);
  }
}