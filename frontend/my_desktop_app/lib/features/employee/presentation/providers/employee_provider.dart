import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/employee/data/datasources/employee_datasources.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/data/repositories/employee_repo_impl.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/usecases/employee_usecase.dart';

final employeeProvider = StateNotifierProvider.autoDispose<EmployeeNotifier, EmployeeState>(
    (ref) => EmployeeNotifier());

class EmployeeNotifier extends StateNotifier<EmployeeState> {
  EmployeeNotifier() : super(EmployeeState.initial());

  final EmployeeUseCase _usecase = EmployeeUseCase(
    repoManagementImpl: EmployeeRepoImpl(
        dataSources: EmployeeRemoteDataSourceImpl(apiServices: ApiServices())),
      repoImpl: EmployeeRepoImpl(
          dataSources:
              EmployeeRemoteDataSourceImpl(apiServices: ApiServices())));

  Future<bool> addEmployee(EmployeeCreateParams prams) async {
    final response = await _usecase.addEmployee(prams);
    return response.fold(
      (err){
        if (err is ValidationFailure){
        state = state.copyWith(errorMessage: err.message, errorList: err.errors);
        return false;  
        }
        state = state.copyWith(errorMessage: err.message);
        return false;
      },
      (succ){
        state = state.copyWith(
        employees: [...state.employees, succ],
      );
      return true;
      }
    );
  }
  void clearState(){
    state = EmployeeState.initial();
  }
  Future<void> deleteEmployee(EmployeeDeleteParams prams) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _usecase.deleteEmployee(prams);
      response.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (_) => state = state.copyWith(
          isLoading: false,
          employees:
              state.employees.where((org) => org.id != prams.employeeId).toList(),
          errorMessage: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete organization: $e',
      );
    }
  }

  Future<bool> employeeStatusChange(EmployeeStatusChangeParams params) async {
  final response = await _usecase.employeeStatusChange(params);
  return response.fold(
    (err) {
      print(err.message);
      return false;
    },
    (succ) {
      final List<EmployeeEntities> updatedEmployees = [...state.employees];

      final index = updatedEmployees.indexWhere((e) => e.id == params.employeeId);
      if (index != -1) {
        updatedEmployees[index].status = params.status;
      }

      state = state.copyWith(
        isLoading: false,
        employees: updatedEmployees,
        errorMessage: null,
        errorList: null,
      );
      return true;

    },
  );
}


  Future<List<EmployeeEntities>> getAllEmployees([EmployeeReadParams? prams]) async {
    final response = await _usecase.getEmployee(prams);
    return response.fold(
      (err) => throw Exception(err.message),
      (succ){
        state = state.copyWith(
        employees: succ,
        );
        return succ;
      }
    );
  }

  Future<void> updateEmployee(EmployeeUpdateParams prams) async {
    final response = await _usecase.updateEmployee(prams);

    response.fold((err) => err, (succ) {
      final index = state.employees.indexWhere((e) => e.id == succ.id);
      if (index != -1) {
        state.employees[index] = succ;
        state = state.copyWith(employees: [...state.employees]);
      }
    });
  }
}

class EmployeeState {
  final List<EmployeeEntities> employees;
  final bool isLoading;
  final String? errorMessage;
  final List<dynamic>? errorList;

  EmployeeState({
    required this.employees,
    required this.isLoading,
    this.errorMessage,
    this.errorList,
  });

  EmployeeState copyWith({List<EmployeeEntities>? employees, bool? isLoading, String? errorMessage, String? successMessage, List<dynamic>? errorList}) {
    return EmployeeState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      errorList: errorList
    );
  }

  factory EmployeeState.initial() => EmployeeState(
      employees: [],
      isLoading: false,
      errorMessage: null,
      errorList: null,
    );
}
