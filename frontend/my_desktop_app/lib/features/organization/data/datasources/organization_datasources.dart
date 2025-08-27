import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/apiException/api_exception.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/core/url/url.dart';

abstract class OrganizationDatasources {
  Future<Either<Failure, Map<String, dynamic>>> get(
      {Map<String, dynamic>? prams});
  Future<Either<Failure, Map<String, dynamic>>> create(
      {required Map<String, dynamic> prmas});
  Future<Either<Failure, bool>> delete(
      {required Map<String, dynamic> prams});
  Future<Either<Failure, Map<String, dynamic>>> update(
      {required Map<String, dynamic> prams});
}

class OrganizationDatasourcesImpl implements OrganizationDatasources {
  final ApiServices _api;
  OrganizationDatasourcesImpl({required ApiServices services})
      : _api = services;

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(
      {Map<String, dynamic>? prams}) async {
    try {
      final response = await _api.getRequest(
          endPoint: ServerUrl.userGetOrganization, queryParameters: prams);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> create(
      {required Map<String, dynamic> prmas}) async {
    try {
      final response = await _api.postRequest(
          endPoint: ServerUrl.userCreateOrganization, body: prmas);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> update(
      {required Map<String, dynamic> prams}) async {
    try {
      final response = await _api.postRequest(
        endPoint: ServerUrl.userUpdateOrganization,
        queryParameters: prams,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(
      {required Map<String, dynamic> prams}) async {
    try {
      final response = await _api.deleteRequest(
        endPoint: ServerUrl.userDeleteOrganization,
        queryParameters: prams,
      );
      if (response.statusCode == 204){
        
        return Right(true);

      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data);
      } else {
        return Left(
            Failure(message: response.data?['message'] ?? 'Request failed'));
      }
    } on ApiException catch (err) {
      if (err is ValidationException) {
        return Left(ValidationFailure(errors: err.errors, msg: err.message));
      }
      return Left(Failure(message: err.message));
    } catch (err) {
      return Left(Failure(message: err.toString()));
    }
  }
}
// // ------------------------------------ Abstract Classes --------------------------------
// abstract class OrganizationDataSources<Type, Prams> {
//   Future<Type> call({required Prams prams});
// }

// // ----------------------------------- Concurrent Classes --------------------------------

// // ------------------------------------
// //               Create               -
// // ------------------------------------
// class OrganizationCreateDataSources extends OrganizationDataSources<
//     Either<Failure, OrganizationEntities>, OrganiztionCreatePrams> {
//   final ApiServices services;
//   OrganizationCreateDataSources(this.services);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call(
//       {required OrganiztionCreatePrams prams}) async {
//     var response = await services.postRequest(
//         endPoint: '/organizations-create', body: prams.toJson());

//     return response.fold((err) => Left(Failure(message: err.message)), (succ) {
//       if (succ.statusCode == 201) {
//         return Right(OrganizationResponseModel.fromJson(succ.data));
//       } else {
//         return Left(Failure(message: 'Failed'));
//       }
//     });
//   }
// }

// // ------------------------------------
// //               Update               -
// // ------------------------------------
// class OrganizationUpdateDataSources extends OrganizationDataSources<
//     Either<Failure, OrganizationEntities>, OrganizationUpdatePrams> {
//   final ApiServices services;
//   OrganizationUpdateDataSources(this.services);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call(
//       {required OrganizationUpdatePrams prams}) async {
//     var response = await services.postRequest(
//         endPoint: '/organizations-update', body: prams.toJson());

//     return response.fold((err) => Left(Failure(message: err.message)), (succ) {
//       if (succ.statusCode == 200) {
//         return Right(OrganizationResponseModel.fromJson(succ.data));
//       } else {
//         return Left(Failure(message: 'Failed'));
//       }
//     });
//   }
// }

// // ------------------------------------
// //               Delete               -
// // ------------------------------------
// class OrganizationDeleteDataSources extends OrganizationDataSources<
//     Either<Failure, OrganizationEntities>, OrganizationDeletePrams> {
//   final ApiServices services;
//   OrganizationDeleteDataSources(this.services);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call(
//       {required OrganizationDeletePrams prams}) async {
//     var response = await services.postRequest(
//         endPoint: '/organizations-delete', queryParameters: prams.toJson());

//     return response.fold((err) => Left(Failure(message: err.message)), (succ) {
//       if (succ.statusCode == 201) {
//         return Right(OrganizationResponseModel.fromJson(succ.data));
//       } else {
//         return Left(Failure(message: 'Failed'));
//       }
//     });
//   }
// }

// // ------------------------------------
// //               Read                 -
// // ------------------------------------
// class OrganizationReadDataSources extends OrganizationDataSources<
//     Either<Failure, List<OrganizationEntities>>, OrganizationReadPrams> {
//   final ApiServices services;
//   OrganizationReadDataSources(this.services);

//   @override
//   Future<Either<Failure, List<OrganizationEntities>>> call(
//       {required OrganizationReadPrams prams}) async {
//     var response = await services.postRequest(
//       endPoint: '/organizations-read',
//       queryParameters: prams.toJson(),
//       body: prams.toJson(),
//     );

//     return response.fold((err) => Left(Failure(message: err.message)), (succ) {
//       if (succ.statusCode == 200) {
//         List<dynamic> data = succ.data;
//         List<OrganizationResponseModel> organizations = data
//             .map((item) => OrganizationResponseModel.fromJson(
//                 item as Map<String, dynamic>))
//             .toList();
//         return Right(organizations);
//       } else {
//         return Left(Failure(message: 'Failed'));
//       }
//     });
//   }
// }
