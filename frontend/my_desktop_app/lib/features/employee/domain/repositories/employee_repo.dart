import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';


abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntities>>> getEmployees([EmployeeReadParams? prams]);
  Future<Either<Failure, EmployeeEntities>> addEmployee(EmployeeCreateParams prams);
  Future<Either<Failure, EmployeeEntities>> updateEmployee(EmployeeUpdateParams prams);
  Future<Either<Failure, bool>> deleteEmployee(EmployeeDeleteParams prams);
}


abstract class EmployeeManagementRepository {
  Future<Either<Failure, EmployeeEntities>> employeeStatusChange(EmployeeStatusChangeParams prams);
  Future<Either<Failure, bool>> employeeImageAllowToProcessForToken(EmployeeImageAllowParams prams);
  Future<Either<Failure, bool>> employeeImageRejectToProcessForToken(EmployeeImageAllowParams prams);
}