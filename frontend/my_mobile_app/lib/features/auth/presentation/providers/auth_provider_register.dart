import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_mobile_app/core/network/network_info.dart';
import 'package:my_mobile_app/core/services/api_services.dart';
import 'package:my_mobile_app/core/services/local_database_service.dart';
import 'package:my_mobile_app/core/services/token_service.dart';
import 'package:my_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:my_mobile_app/features/auth/data/datasources/auth_remote_impl.dart';
import 'package:my_mobile_app/features/auth/data/repositories/basic_auth_impl.dart';
import 'package:my_mobile_app/features/auth/domain/usecases/auth_usecase.dart';

final apiServiceProvider = Provider((ref) => ApiServices());
final tokenServiceProvider = Provider((ref) => TokenService());
final localDbProvider = Provider((ref) => LocalDatabaseService());
final connectivityProvider = Provider((ref) => Connectivity());

final authUsecaseProvider = Provider<AuthUsecase>((ref) {
  return AuthUsecaseImpl(
    authRepo: AuthRepoImpl(
      remoteDataSource:
          AuthRemoteDataSourcesImpl(api: ref.read(apiServiceProvider)),
      localDataSource: AuthLocalDataSourceImpl(
        tokenService: ref.read(tokenServiceProvider),
        localDb: ref.read(localDbProvider),
      ),
      networkInfo: NetworkInfoImpl(ref.read(connectivityProvider)),
    ),
  );
});
