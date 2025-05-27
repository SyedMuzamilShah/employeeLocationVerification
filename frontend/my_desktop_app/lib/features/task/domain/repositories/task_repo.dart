import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_managemanat_entities.dart';


abstract class TaskRepo {
  Future<Either<Failure, List<TaskEntities>>> get([TaskReadParams? params]);
  Future<Either<Failure, TaskEntities>> create(TaskCreateParams params);
  Future<Either<Failure, TaskEntities>> update(TaskUpdateParams params);
  Future<Either<Failure, bool>> delete(TaskDeleteParams params);
  Future<Either<Failure, List<TaskAssignmentEntity>>> taskDetailGet(TaskDetailGetParams params);
}

abstract class TaskManagementRepo {
  Future<Either<Failure, TaskManagementEntities>> taskAssigned(TaskAssignParams params);
  Future<Either<Failure, TaskManagementEntities>> taskDeassigned(TaskDeAssignParams params);
  Future<Either<Failure, bool>> taskVerified(TaskVerifiedParams params);
  Future<Either<Failure, void>> taskStatusChange(TaskStatusChangeParams params);
}