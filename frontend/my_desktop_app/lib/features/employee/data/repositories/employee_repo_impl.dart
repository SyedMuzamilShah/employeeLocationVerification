import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/apiException/api_exception.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/employee/data/datasources/employee_datasources.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';
import 'package:my_desktop_app/features/employee/domain/entities/employee_entities.dart';
import 'package:my_desktop_app/features/employee/domain/repositories/employee_repo.dart';

class EmployeeRepoImpl
    implements EmployeeRepository, EmployeeManagementRepository {
  final EmployeeRemoteDataSource dataSources;
  EmployeeRepoImpl({required this.dataSources});

  @override
  Future<Either<Failure, EmployeeEntities>> addEmployee(
      EmployeeCreateParams prams) async {
    try {
      final response = await dataSources.addEmployee(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeEntities>>> getEmployees(
      [EmployeeReadParams? prams]) async {
    try {
      final response = await dataSources.getEmployees(prams?.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntities>> updateEmployee(
      EmployeeUpdateParams prams) async {
    try {
      final response = await dataSources.wholeDataUpdate(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteEmployee(EmployeeDeleteParams prams) async {
    try {
      final response = await dataSources.deleteEmployee(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntities>> employeeStatusChange(
      EmployeeStatusChangeParams prams) async {
    try {
      final response = await dataSources.employeeStatusChange(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> employeeImageAllowToProcessForToken(EmployeeImageAllowParams prams) async {
    try {
      final response = await dataSources.allowPictureForProcessing(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }
  
  @override
  Future<Either<Failure, bool>> employeeImageRejectToProcessForToken(EmployeeImageAllowParams prams) async {
    try {
      final response = await dataSources.rejectPictureForProcessing(prams.toJson());
      return Right(response);
    } catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      } else if (err is ApiException) {
        return Left(Failure(message: err.message));
      } else if (err is NetworkException) {
        return Left(Failure(message: err.message));
      } else if (err is ServerException) {
        return Left(Failure(message: err.message));
      }
      return Left(Failure(message: err.toString()));
    }
  }
}
