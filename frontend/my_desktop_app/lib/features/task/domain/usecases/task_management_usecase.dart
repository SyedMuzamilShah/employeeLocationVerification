import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_managemanat_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/task_repo.dart';

abstract class TaskManagementUsecase {
  Future<Either<Failure, TaskManagementEntities>> taskAssign(TaskAssignParams params);
  Future<Either<Failure, TaskManagementEntities>> taskDeassign(TaskDeAssignParams params);
  Future<Either<Failure, bool>> taskVerified(TaskVerifiedParams params);
  Future<Either<Failure, void>> taskStatusChange(TaskStatusChangeParams params);
}

class TaskManagementUsecaseImpl extends TaskManagementUsecase {
  final TaskManagementRepo _repo;
  TaskManagementUsecaseImpl({required TaskManagementRepo repo}) : _repo = repo;

  @override
  Future<Either<Failure, TaskManagementEntities>> taskAssign(TaskAssignParams params) async {
    // final organization = await _repo.get(params);
    final organization = await _repo.taskAssigned(params);

    return organization.fold((err) => Left(err), (succ) => Right(succ));
  }

  @override
  Future<Either<Failure, TaskManagementEntities>> taskDeassign(TaskDeAssignParams params) async {
    final response = await _repo.taskDeassigned(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }

  @override
  Future<Either<Failure, bool>> taskVerified(TaskVerifiedParams params) async {
    final response = await _repo.taskVerified(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  
  @override
  Future<Either<Failure, void>> taskStatusChange(TaskStatusChangeParams params) async  {
    final response = await _repo.taskStatusChange(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
}
