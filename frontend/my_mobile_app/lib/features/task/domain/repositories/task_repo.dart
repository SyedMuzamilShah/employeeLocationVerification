import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_completed_entities.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';


abstract class TaskRepo {
  Future<Either<Failure, List<TaskEntities>>> readTask([TaskReadParams? params]);
  Future<Either<Failure, TaskEntities>> getTaskById(TaskGetByIdParams params);
  Future<Either<Failure, TaskCompletedEntities>> completeTask(TaskCompletingParams params);
  Future<Either<Failure, String>> completeTaskCheckOut(TaskCompletingCheckOutParams params);
}