import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_prams.dart';
import 'package:my_desktop_app/features/task/data/models/response/task_detail_response.dart';
import 'package:my_desktop_app/features/task/data/models/response/task_response.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_detail_entities.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/task_repo.dart';

class TaskRepoImpl extends TaskRepo {
  final TaskDataSources _dataSources;

  TaskRepoImpl({required TaskDataSources dataSources,})
      : _dataSources = dataSources;

  @override
  Future<Either<Failure, TaskEntities>> create(TaskCreateParams params) async {
    final response = await _dataSources.taskCreate(params.toJson());
    return response.fold(
      (err) => Left(err),
      (succ){
        final TaskEntities model = TaskResponseModel.fromJson(succ['data']['task']);
        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> delete(TaskDeleteParams params) async {
    final response = await _dataSources.taskDelete(params.toJson());
    return response.fold((err) => Left(err),
        (succ){
          return Right(true);
        });
  }

  @override
  Future<Either<Failure, List<TaskEntities>>> get(
      [TaskReadParams? params]) async {
    final response = await _dataSources.taskRead(params?.toJson()
    );
    return response.fold((err) => Left(err), (succ) {
      List data = succ['data']['tasks'];
      print("Task Create Model");
      List<TaskEntities> task =
          data.map((e) => TaskResponseModel.fromJson(e)).toList();
      print("Reading the data");
      print(task);
      return Right(task);
    });
  }

  @override
  Future<Either<Failure, TaskEntities>> update(TaskUpdateParams params) async {
    final response = await _dataSources.taskUpdate(params.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) => Right(TaskResponseModel.fromJson(succ['data'])),
    );
  }

  @override
Future<Either<Failure, List<TaskAssignmentEntity>>> taskDetailGet(TaskDetailGetParams params) async {
  final response = await _dataSources.taskDetailGet(params.toJson());
  return response.fold(
    (err) => Left(err),
    (succ) {
      List data = succ['data']['tasks'];
      print(data);
      return Right(
        data.map((e) => TaskAssignmentModel.fromJson(e)).toList()
      );
    },
  );
}

}
