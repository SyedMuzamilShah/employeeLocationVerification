import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/network/network_info.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/core/services/local_database_service.dart';
import 'package:my_desktop_app/core/services/token_service.dart';
import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:my_desktop_app/features/auth/data/datasources/auth_remote_impl.dart';
import 'package:my_desktop_app/features/auth/data/models/request/login_params.dart';
import 'package:my_desktop_app/features/auth/data/models/request/register_params.dart';
import 'package:my_desktop_app/features/auth/data/repositories/basic_auth_impl.dart';
import 'package:my_desktop_app/features/auth/domain/entities/user_entities.dart';
import 'package:my_desktop_app/features/auth/domain/usecases/auth_usecase.dart';

/// **StateNotifierProvider for Authentication**
final basicAuthProvider =
    StateNotifierProvider<BasicAuthProviderNotifier, BasicAuthProviderState>(
  (ref) => BasicAuthProviderNotifier(),
);

/// **Notifier for Authentication State Management**
class BasicAuthProviderNotifier extends StateNotifier<BasicAuthProviderState> {
  BasicAuthProviderNotifier() : super(BasicAuthProviderState());

  final AuthUsecase _authUsecase = AuthUsecaseImpl(
      authRepo: AuthRepoImpl(
    remoteDataSource: AuthRemoteDataSourcesImpl(api: ApiServices()),
    localDataSource: AuthLocalDataSourceImpl(
      tokenService: TokenService(),
      localDb: LocalDatabaseService(),
    ),
    networkInfo: NetworkInfoImpl(Connectivity()),
  ));

  /// **Logout User**
  Future<bool> logout() async {

    _setLoadingState();
    final response = await _authUsecase.logout();

    return response.fold(
      (failure) {
        // _setErrorState(failure.message);
        state = state.clear();
        return false;
      },
      (message) {
        _setSuccessState(message);
        state = state.clear();
        return true;
      },
    );
  }

  /// **Register User**
  Future<bool> register({required RegisterParams model}) async {
    _setLoadingState();

    final response = await _authUsecase.register(model);

    return response.fold(
      (failure) {
        if (failure is ValidationFailure) {
          _setValidationErrorState(failure.message, failure.errors);
        } else {
          _setErrorState(failure.message);
        }
        return false;
      },
      (succ) {
        if (kDebugMode) {
          print("Success Called register function");
        }
        // _clearLoadingState();
        state = state.clear();
        state = state.copyWith(successMessage: "User Created Successfully");
        return true;
      },
    );
  }

  void clearState() {
    state = state.clear();
  }

  /// **Login User**
  Future<bool> login(LoginParams pramas) async {
    _setLoadingState();

    final response = await _authUsecase.login(pramas);

    return response.fold(
      (failure) {
        if (failure is ValidationFailure) {
          _setValidationErrorState(failure.message, failure.errors);
        } else {
          _setErrorState(failure.message);
        }
        return false;
      },
      (_) {
        _setSuccessState('Login successful');
        return true;
      },
    );
  }

  /// **Helper Methods for State Management**
  void _setLoadingState() {
    state = state.clear().copyWith(isLoading: true);
  }

  void _setErrorState(String message) {
    state = state.copyWith(errorMessage: message, isLoading: false);
  }

  void _setSuccessState(String message) {
    state = state.copyWith(successMessage: message, isLoading: false);
  }

  void _setValidationErrorState(String message, List<dynamic>? errors) {
    state = state.copyWith(
        errorMessage: message, errorList: errors, isLoading: false);
  }

  void _clearLoadingState() {
    state = state.copyWith(isLoading: false);
  }

  Future<Either<Failure, UserEntities>> getUser() async {
    debugPrint("Get User Function Called With In [Basic Auth Provider]");
    return await _authUsecase.getUser();
  }

  // Future<Either<Failure, bool>> tokenRefresh() async {
  //   return await _authUsecase.refreshToken();
  // }

  Future<Either<Failure, bool>> isLogin() async {
    return await _authUsecase.isLogin();
  }
}

/// **Authentication State Model**
class BasicAuthProviderState {
  final List<dynamic>? errorList;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  BasicAuthProviderState({
    this.errorMessage,
    this.errorList,
    this.successMessage,
    this.isLoading = false,
  });

  BasicAuthProviderState copyWith({
    String? errorMessage,
    List<dynamic>? errorList,
    String? successMessage,
    bool? isLoading,
  }) {
    return BasicAuthProviderState(
      errorList: errorList ?? this.errorList,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  BasicAuthProviderState clear() => BasicAuthProviderState().copyWith(
    errorList: [],
  );
}
