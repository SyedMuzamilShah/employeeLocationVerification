import 'package:fpdart/fpdart.dart';
import 'package:my_mobile_app/core/failure/failure.dart';
import 'package:my_mobile_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_mobile_app/features/task/data/models/request/task_params.dart';
import 'package:my_mobile_app/features/task/data/models/response/task_response.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_completed_entities.dart';
import 'package:my_mobile_app/features/task/domain/entities/task_entities.dart';
import 'package:my_mobile_app/features/task/domain/repositories/task_repo.dart';

class TaskRepoImpl extends TaskRepo {
  final TaskRemoteDataSource _dataSources;

  TaskRepoImpl({
    required TaskRemoteDataSource dataSources,
  }) : _dataSources = dataSources;

  @override
  Future<Either<Failure, List<TaskEntities>>> readTask(
      [TaskReadParams? params]) async {
    final response = await _dataSources.getTasks(params?.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) {
        List data = succ['data'];
        late List<TaskEntities> model;
        try {
          model =
              data.map((e) => TaskResponseModel.fromJson(e)).toList();
        }catch (e){
          print(e);
          return Left(Failure(message: 'Error parsing task data: $e'));
        }
        print(model);
        return Right(model);
      },
    );
  }

  @override
  Future<Either<Failure, TaskCompletedEntities>> completeTask(
      TaskCompletingParams params) async {
    final formData = await params.toFormData();
    // final response = await _dataSources.completingTask(params.toJson());
    final response = await _dataSources.completingTask(formData);
    return response.fold((err) {
      return Left(err);
    }, (succ) {
      var message = succ['message'];
      var data = succ['data'];
      var taskEntities = TaskResponseModel.fromJson(data);
      print(taskEntities.toString());
      final response = TaskCompletedEntities(task: taskEntities, message: message);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, TaskEntities>> getTaskById(
      TaskGetByIdParams params) async {
    final response = await _dataSources.getTaskById(params.toJson());
    return response.fold((err) {
      return Left(err);
    }, (succ) {
      var data = succ['data'];
      return Right(TaskResponseModel.fromJson(data['data']));
    });
  }
  
  @override
  Future<Either<Failure, String>> completeTaskCheckOut(TaskCompletingCheckOutParams params) async {
    final response = await _dataSources.completingTaskCheckout(params.toJson());
    return response.fold((err) {
      return Left(err);
    }, (succ) {
      return Right('Checkout successfully');
    });
  }
}
