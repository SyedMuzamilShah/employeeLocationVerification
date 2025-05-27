// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:my_desktop_app/core/failure/validation_failure.dart';
// import 'package:my_desktop_app/core/network/network_info.dart';
// import 'package:my_desktop_app/core/services/api_services.dart';
// import 'package:my_desktop_app/core/services/local_database_service.dart';
// import 'package:my_desktop_app/core/services/token_service.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:my_desktop_app/features/auth/data/datasources/auth_remote_impl.dart';
// import 'package:my_desktop_app/features/auth/data/models/request/register_request_prams.dart';
// import 'package:my_desktop_app/features/auth/data/repositories/register_repo_impl.dart';
// import 'package:my_desktop_app/features/auth/domain/usecases/register_usecase.dart';

// final registerProvider =
//     StateNotifierProvider<RegisterProviderNotifier, RegisterProviderState>(
//   (ref) => RegisterProviderNotifier(),
// );

// // Notifier Class
// class RegisterProviderNotifier extends StateNotifier<RegisterProviderState> {
//   RegisterProviderNotifier() : super(RegisterProviderState());

//   final RegisterUseCase _usecase = RegisterUseCaseImpl(
//       registerRepo: RegisterRepoImpl(
//           sources: AuthRemoteDataSourcesImpl(api: ApiServices()),
//           authLocalData: AuthLocalDataSourceImpl(
//               tokenService: TokenService(), localDb: LocalDatabaseService()),
//           networkInfo: NetworkInfoImpl(Connectivity())));

//   Future<void> register(
//       {required String name,
//       required String email,
//       required String password,
//       String? phone}) async {
//     // Reset state before making the request
//     state = state.copyWith(
//       isLoading: true,
//       failure: null,
//     );

//     final RegisterRequestPrams prams = RegisterRequestPrams(
//         userName: '',
//         email: email,
//         password: password,
//         name: name,
//         phoneNumber: phone);

//     final response = await _usecase.register(prams: prams);

//     response.fold(
//       (failure) {
//         if (failure is ValidationFailure) {
//           return state = state.copyWith(
//               failure: failure.message,
//               errors: failure.errors,
//               isLoading: false);
//         }
//         state = state.copyWith(failure: failure.message, isLoading: false);
//       },
//       (user) => state = state.copyWith(isLoading: false),
//     );
//   }
// }

// // State Class
// class RegisterProviderState {
//   final String? failure;
//   final bool isLoading;
//   final List<dynamic>? errors;

//   const RegisterProviderState(
//       {this.failure, this.isLoading = false, this.errors});

//   RegisterProviderState copyWith(
//       {String? failure, bool? isLoading, List<dynamic>? errors}) {
//     return RegisterProviderState(
//       // getUser: getUser ?? this.getUser,
//       errors: errors ?? this.errors,
//       failure: failure,
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }
