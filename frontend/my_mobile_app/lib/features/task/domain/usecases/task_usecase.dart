import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_completed_entities.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/domain/repositories/task_repo.dart';

abstract class TaskUseCase {
  Future<Either<Failure, List<TaskEntities>>> readTask(
      [TaskReadParams? params]);
  Future<Either<Failure, TaskCompletedEntities>> completeTask(
      TaskCompletingParams params);
  Future<Either<Failure, String>> completeTaskCheckOutUseCase(
      TaskCompletingCheckOutParams params);
}

class TaskUseCaseImpl extends TaskUseCase {
  final TaskRepo _repo;
  TaskUseCaseImpl({required TaskRepo repo}) : _repo = repo;

  @override
  Future<Either<Failure, List<TaskEntities>>> readTask(
      [TaskReadParams? params]) async {
    // final organization = await _repo.get(params);
    final organization = await _repo.readTask(params);

    return organization.fold((err) => Left(err), (succ) => Right(succ));
  }

  @override
  Future<Either<Failure, TaskCompletedEntities>> completeTask(
      TaskCompletingParams params) async {
    final response = await _repo.completeTask(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  
  @override
  Future<Either<Failure, String>> completeTaskCheckOutUseCase(TaskCompletingCheckOutParams params) async {
    final response = await _repo.completeTaskCheckOut(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
}
