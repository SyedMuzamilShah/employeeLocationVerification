import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';
import 'package:my_desktop_app/features/organization/domain/repositories/organization_repo.dart';

abstract class OrganizationUsecase {
  Future<Either<Failure, List<OrganizationEntities>>> get({OrganizationReadPrams? prams});
  Future<Either<Failure, OrganizationEntities>> create(OrganiztionCreatePrams prams);
  Future<Either<Failure, OrganizationEntities>> update(OrganizationUpdatePrams prams);
  Future<Either<Failure, bool>> delete(OrganizationDeletePrams prams);

  Future<Map<String, dynamic>?> isOrganizationSaved();
  Future<void> organizationSaved(Map<String, dynamic> organization);
  Future<void> clearOrganization();
}


class OrganizationUseCaseImpl extends OrganizationUsecase {
  final OrganizationRepo _repo;
  OrganizationUseCaseImpl({required OrganizationRepo repo}) : _repo = repo;

  @override
  Future<Either<Failure, List<OrganizationEntities>>> get({OrganizationReadPrams? prams}) async {
    final organization = await _repo.get(prams: prams);
    
    return organization.fold(
      (err) => Left(err), 
      (succ) => Right(succ)
    );
  }
  
  @override
  Future<Either<Failure, OrganizationEntities>> create(OrganiztionCreatePrams prams) async {
    final response = await _repo.create(prams: prams);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  
  @override
  Future<Either<Failure, bool>> delete(OrganizationDeletePrams prams) async {
    final response = await _repo.delete(prams: prams);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  
  @override
  Future<Either<Failure, OrganizationEntities>> update(OrganizationUpdatePrams prams) async {
    final response = await _repo.update(prams: prams);
    return response.fold(
      (err) => Left(err),
      (succ) => Right(succ),
    );
  }
  

  @override
  Future<Map<String, dynamic>?> isOrganizationSaved() async {
    return _repo.isOrganizationSaved();
  }
  
  @override
  Future<void> organizationSaved(Map<String, dynamic> organization) async {
    await _repo.organizationSaved(organization);
  }
  
  @override
  Future<void> clearOrganization() async {
    await _repo.clearOrganization();
  }
}


// class OrganizationUseCaseImpl extends OrganizationUsecase{
//   final OrganizationRepo _repo;
//   OrganizationUseCaseImpl({required OrganizationRepo repo}) : _repo = repo;

//   @override
//   Future<Either<Failure, List<OrganizationEntities>>> get({OrganizationReadPrams? prams}) async {
//     final organization = await _repo.get();

//     return organization.fold(
//       (err) => Left(err), 
//       (succ) => Right(succ));
//   }
  
//   @override
//   Future<Either<Failure, OrganizationEntities>> create(OrganiztionCreatePrams prams) {
//     // TODO: implement create
//     throw UnimplementedError();
//   }
  
//   @override
//   Future<Either<Failure, OrganizationEntities>> delete(OrganizationDeletePrams prams) {
//     // TODO: implement delete
//     throw UnimplementedError();
//   }
  
//   @override
//   Future<Either<Failure, OrganizationEntities>> update(OrganizationUpdatePrams prams) {
//     // TODO: implement update
//     throw UnimplementedError();
//   }
// }




// // ------------------------------------
// //               Create               -
// // ------------------------------------
// class OrganizationCreateUsecase extends UseCaseAbstract<Either<Failure, OrganizationEntities>, OrganiztionCreatePrams> {
//   final OrganizationCreateRepo repo;
//   OrganizationCreateUsecase(this.repo);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call({required OrganiztionCreatePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Update               -
// // ------------------------------------
// class OrganizationUpdateUsecase extends UseCaseAbstract<Either<Failure, OrganizationEntities>, OrganizationUpdatePrams> {
//   final OrganizationUpdateRepo repo;
//   OrganizationUpdateUsecase(this.repo);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationUpdatePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Delete               -
// // ------------------------------------
// class OrganizationDeleteUsecase extends UseCaseAbstract<Either<Failure, OrganizationEntities>, OrganizationDeletePrams> {
//   final OrganizationDeleteRepo repo;
//   OrganizationDeleteUsecase(this.repo);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationDeletePrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }

// // ------------------------------------
// //               Read                 -
// // ------------------------------------
// class OrganizationReadUsecase extends UseCaseAbstract<Either<Failure, OrganizationEntities>, OrganizationReadPrams> {
//   final OrganizationReadRepo repo;
//   OrganizationReadUsecase(this.repo);

//   @override
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationReadPrams prams}) async {
//     return await repo.call(prams: prams);
//   }
// }