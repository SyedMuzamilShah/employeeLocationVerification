import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/employee/data/datasources/employee_datasources.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/data/repositories/employee_repo_impl.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/usecases/employee_usecase.dart';

final employeeDetailProvider =
    StateNotifierProvider<EmployeeDetailNotifier, EmployeeDetailState>(
        (ref) => EmployeeDetailNotifier());

class EmployeeDetailNotifier extends StateNotifier<EmployeeDetailState> {
  EmployeeDetailNotifier() : super(EmployeeDetailState.initial());

  final EmployeeUseCase _usecase = EmployeeUseCase(
      repoManagementImpl: EmployeeRepoImpl(
          dataSources:
              EmployeeRemoteDataSourceImpl(apiServices: ApiServices())),
      repoImpl: EmployeeRepoImpl(
          dataSources:
              EmployeeRemoteDataSourceImpl(apiServices: ApiServices())));

  void clearState() {
    state = EmployeeDetailState.initial();
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


  Future<void> rejectImage(EmployeeImageAllowParams params) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _usecase.employeeImageRejectForProcessing(params);
      response.fold(
          (failure){
            print(failure.message);
            state = state.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              );
          },
              
              (_) {
        final List<EmployeeEntities> updatedEmployees = [...state.employees];

        final index =
            updatedEmployees.indexWhere((e) => e.id == params.employeeId);
        if (index != -1) {
          updatedEmployees[index].imageAcceptedForToken = true;
        }

        state = state.copyWith(
          isLoading: false,
          employees: updatedEmployees,
          errorMessage: null,
          errorList: null,
        );
        return true;
      });
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete organization: $e',
      );
    }
  }

  Future<void> imageAllow(EmployeeImageAllowParams params) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _usecase.employeeImageAllowForProcessing(params);
      response.fold(
          (failure){
            print(failure.message);
            state = state.copyWith(
                isLoading: false,
                errorMessage: failure.message,
              );
          },
              
              (_) {
        final List<EmployeeEntities> updatedEmployees = [...state.employees];

        final index =
            updatedEmployees.indexWhere((e) => e.id == params.employeeId);
        if (index != -1) {
          updatedEmployees[index].imageAcceptedForToken = true;
        }

        state = state.copyWith(
          isLoading: false,
          employees: updatedEmployees,
          errorMessage: null,
          errorList: null,
        );
        return true;
      });
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

        final index =
            updatedEmployees.indexWhere((e) => e.id == params.employeeId);
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

class EmployeeDetailState {
  final List<EmployeeEntities> employees;
  final bool isLoading;
  final String? errorMessage;
  final List<dynamic>? errorList;

  EmployeeDetailState({
    required this.employees,
    required this.isLoading,
    this.errorMessage,
    this.errorList,
  });

  EmployeeDetailState copyWith(
      {List<EmployeeEntities>? employees,
      bool? isLoading,
      String? errorMessage,
      String? successMessage,
      List<dynamic>? errorList}) {
    return EmployeeDetailState(
        employees: employees ?? this.employees,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        errorList: errorList);
  }

  factory EmployeeDetailState.initial() => EmployeeDetailState(
        employees: [],
        isLoading: false,
        errorMessage: null,
        errorList: null,
      );
}
