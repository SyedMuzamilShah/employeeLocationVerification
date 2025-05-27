// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_desktop_app/core/network/network_info.dart';
// import 'package:my_desktop_app/core/services/api_services.dart';
// import 'package:my_desktop_app/core/services/local_database_service.dart';
// import 'package:my_desktop_app/core/services/token_service.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_remote_impl.dart';
// import 'package:my_desktop_app/features/auth/data/repositories/logout_repo_impl.dart';
// import 'package:my_desktop_app/features/auth/domain/usecases/logout_usecase.dart';

// final logoutProvider = AsyncNotifierProvider<LogoutProviderNotifier, bool>(
//   () => LogoutProviderNotifier(),
// );

// class LogoutProviderNotifier extends AsyncNotifier<bool> {
//   final LogoutUsecase useCase = LogoutUsecaseImpl(
//       repo: LogoutRepoImpl(
//           sources: AuthRemoteDataSourcesImpl(api: ApiServices()),
//           authLocalData: AuthLocalDataSourceImpl(tokenService: TokenService(), localDb: LocalDatabaseService()),
//           networkInfo: NetworkInfoImpl(Connectivity())));

//   @override
//   Future<bool> build() async {
//     return false;
//   }

//   Future<bool> logout() async {
//     state = AsyncLoading();

//     final response = await useCase.logout();
    
//     bool isLogout = response.fold((failure) => false, (success) => true);

//     state = AsyncData(isLogout);

//     return isLogout;
//   }
// }
