import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/task_repo.dart';

abstract class TaskUseCase {
  Future<Either<Failure, List<TaskEntities>>> get([TaskReadParams? params]);
  Future<Either<Failure, TaskEntities>> create(TaskCreateParams params);
  Future<Either<Failure, TaskEntities>> update(TaskUpdateParams params);
  Future<Either<Failure, bool>> delete(TaskDeleteParams params);
  Future<Either<Failure, List<TaskAssignmentEntity>>> getTaskDetail(TaskDetailGetParams params);
}

class TaskUseCaseImpl extends TaskUseCase {
  final TaskRepo _repo;
  TaskUseCaseImpl({required TaskRepo repo}) : _repo = repo;

  @override
  Future<Either<Failure, List<TaskEntities>>> get(
      [TaskReadParams? params]) async {
    // final organization = await _repo.get(params);
    final organization = await _repo.get(params);

    return organization.fold((err) => Left(err), (succ) => Right(succ));
  }

  @override
  Future<Either<Failure, TaskEntities>> create(TaskCreateParams params) async {
    final response = await _repo.create(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }

  @override
  Future<Either<Failure, bool>> delete(TaskDeleteParams params) async {
    final response = await _repo.delete(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }

  @override
  Future<Either<Failure, TaskEntities>> update(TaskUpdateParams params) async {
    final response = await _repo.update(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  
  @override
  Future<Either<Failure, List<TaskAssignmentEntity>>> getTaskDetail(TaskDetailGetParams params) async {
    final response = await _repo.taskDetailGet(params);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
}
