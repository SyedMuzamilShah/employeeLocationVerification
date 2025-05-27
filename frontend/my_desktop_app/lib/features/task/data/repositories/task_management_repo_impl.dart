import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_managment_parmas.dart';
import 'package:my_desktop_app/features/task/data/models/request/task_verified_params.dart';
import 'package:my_desktop_app/features/task/data/models/response/task_management_response.dart';
import 'package:my_desktop_app/features/task/domain/entities/task_managemanat_entities.dart';
import 'package:my_desktop_app/features/task/domain/repositories/task_repo.dart';

class TaskManagementRepoImpl extends TaskManagementRepo {
  final TaskManagamentDataSources _dataSources;

  TaskManagementRepoImpl({required TaskManagamentDataSources dataSources})
      : _dataSources = dataSources;

  @override
  Future<Either<Failure, TaskManagementEntities>> taskAssigned(
      TaskAssignParams params) async {
    final response = await _dataSources.taskAssign(params.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) {
        print(succ['data']['task']);
        return Right(
            TaskManagementResponseModel.fromJson(succ['data']['task']));
      },
    );
  }

  @override
  Future<Either<Failure, TaskManagementEntities>> taskDeassigned(
      TaskDeAssignParams params) async {
    final response = await _dataSources.taskDeassign(params.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) => Right(TaskManagementResponseModel.fromJson(succ['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> taskVerified(
      TaskVerifiedParams params) async {
    final response = await _dataSources.taskVerified(params.toJson());
    return response.fold(
      (err) => Left(err),
      (succ){
        return Right(true);
      },
    );
  }

  @override
  Future<Either<Failure, void>> taskStatusChange(
      TaskStatusChangeParams params) async {
    final response = await _dataSources.taskStatusChange(params.toJson());
    return response.fold((err) => Left(err), (succ) {
      return Right(null);
    });
  }
}
