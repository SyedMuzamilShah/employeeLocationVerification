import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
// import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/repositories/employee_repo.dart';



class EmployeeUseCase {
  final EmployeeRepository repoImpl;
  final EmployeeManagementRepository repoManagementImpl;
  EmployeeUseCase({required this.repoImpl, required this.repoManagementImpl});

  Future<Either<Failure, EmployeeEntities>> addEmployee(EmployeeCreateParams prams) async {
    return await repoImpl.addEmployee(prams);
  }

  Future<Either<Failure, EmployeeEntities>> updateEmployee(EmployeeUpdateParams prams) async {
    return await repoImpl.updateEmployee(prams);
  }

  Future<Either<Failure, List<EmployeeEntities>>> getEmployee([EmployeeReadParams? prams]) async {
    return await repoImpl.getEmployees(prams);
  }

  Future<Either<Failure, bool>> deleteEmployee(EmployeeDeleteParams prams) async {
    return await repoImpl.deleteEmployee(prams);
  }

  Future<Either<Failure, EmployeeEntities>> employeeStatusChange(EmployeeStatusChangeParams prams) async {
    return await repoManagementImpl.employeeStatusChange(prams);
  }


  Future<Either<Failure, bool>> employeeImageAllowForProcessing(EmployeeImageAllowParams prams) async {
    return await repoManagementImpl.employeeImageAllowToProcessForToken(prams);
  }

  Future<Either<Failure, bool>> employeeImageRejectForProcessing(EmployeeImageAllowParams prams) async {
    return await repoManagementImpl.employeeImageRejectToProcessForToken(prams);
  }


}


// // ------------------------------------
// //               Create               -
// // ------------------------------------
// class EmployeeCreateUsecase extends UseCaseAbstract<Either<Failure, EmployeeEntities>, EmployeeCreatePrams> {
//   final EmployeeCreateRepositories repo;
//   EmployeeCreateUsecase(this.repo);

//   @override
//   Future<Either<Failure, EmployeeEntities>> call({required EmployeeCreatePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Update               -
// // ------------------------------------
// class EmployeeUpdateUsecase extends UseCaseAbstract<Either<Failure, EmployeeEntities>, EmployeeUpdatePrams> {
//   final EmployeeUpdateRepositories repo;
//   EmployeeUpdateUsecase(this.repo);

//   @override
//   Future<Either<Failure, EmployeeEntities>> call({required EmployeeUpdatePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Delete               -
// // ------------------------------------
// class EmployeeDeleteUsecase extends UseCaseAbstract<Either<Failure, EmployeeEntities>, EmployeeDeletePrams> {
//   final EmployeeDeleteRepositories repo;
//   EmployeeDeleteUsecase(this.repo);

//   @override
//   Future<Either<Failure, EmployeeEntities>> call({required EmployeeDeletePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Read                 -
// // ------------------------------------
// class EmployeeReadUsecase extends UseCaseAbstract<Either<Failure, EmployeeEntities>, EmployeeReadPrams> {
//   final EmployeeReadRepositories repo;
//   EmployeeReadUsecase(this.repo);

//   @override
//   Future<Either<Failure, EmployeeEntities>> call({required EmployeeReadPrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }