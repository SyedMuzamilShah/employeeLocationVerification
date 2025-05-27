import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/services/provider/api_services_provider.dart';
import 'package:my_mobile_app/features/task/data/datasources/task_datasources.dart';
import 'package:my_mobile_app/features/task/data/repositories/task_repo_impl.dart';
import 'package:my_mobile_app/features/task/domain/repositories/task_repo.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>(
  (ref) => TaskRemoteDataSourceImpl(services: ref.read(apiServiceProvider)),
);

final taskRepoProvider = Provider<TaskRepo>(
  (ref) => TaskRepoImpl(dataSources: ref.read(taskRemoteDataSourceProvider)),
);