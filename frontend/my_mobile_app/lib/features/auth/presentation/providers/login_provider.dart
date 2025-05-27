// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_desktop_app/core/failure/validation_failure.dart';
// import 'package:my_desktop_app/core/network/network_info.dart';
// import 'package:my_desktop_app/core/services/api_services.dart';
// import 'package:my_desktop_app/core/services/local_database_service.dart';
// import 'package:my_desktop_app/core/services/token_service.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_remote_impl.dart';
// import 'package:my_desktop_app/features/auth/data/models/request/login_request_prams.dart';
// import 'package:my_desktop_app/features/auth/data/repositories/login_repo_impl.dart';
// import 'package:my_desktop_app/features/auth/domain/usecases/login_usecase.dart';

// final loginProvider =
//     StateNotifierProvider<LoginProviderNotifier, LoginProviderState>((ref) {
//   return LoginProviderNotifier();
// });

// class LoginProviderNotifier extends StateNotifier<LoginProviderState> {
//   LoginProviderNotifier() : super(LoginProviderState());

//   final LoginUseCase usecase = LoginUseCaseImpl(
//       loginRepo: LoginRepoImpl(

//           // For access the api
//           sources: AuthRemoteDataSourcesImpl(api: ApiServices()),

//           // store token and user
//           authLocalData: AuthLocalDataSourceImpl(tokenService: TokenService(), localDb: LocalDatabaseService()),
          
//           // check the internet
//           networkInfo: NetworkInfoImpl(Connectivity())));

//   Future<bool> login({required String email, required String password}) async {
//     state = state.clear();
//     state = state.copyWith(isLoading: true);

//     final LoginRequestPrams prams =
//         LoginRequestPrams(email: email, password: password);

//     final response = await usecase.login(prams: prams);
//     response.fold((failure) {
//       if (failure is ValidationFailure) {
//         state = state.copyWith(errorList: failure.errors, isLoading: false);
//         return false;
//       }
//       state = state.copyWith(errorMessage: failure.message, isLoading: false);
//       return false;
//     }, (success) {
//       state = state.copyWith(
//         successMessage: 'Login successful',
//         isLoading: false,
//       );
//       return true;
//     });

//     return false;
//   }
// }

// class LoginProviderState {
//   final List? errorList;
//   final bool isLoading;
//   final String? errorMessage;
//   final String? successMessage;

//   LoginProviderState(
//       {this.errorMessage,
//       this.errorList,
//       this.successMessage,
//       this.isLoading = false});

//   LoginProviderState copyWith(
//       {String? errorMessage,
//       List? errorList,
//       String? successMessage,
//       bool? isLoading}) {
//     return LoginProviderState(
//         errorList: errorList ?? this.errorList,
//         errorMessage: errorMessage ?? this.errorMessage,
//         successMessage: successMessage ?? this.successMessage,
//         isLoading: isLoading ?? this.isLoading);
//   }

//   LoginProviderState clear() {
//     return LoginProviderState();
//   }
// }
