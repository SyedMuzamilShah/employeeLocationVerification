import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';

// Get
// abstract class OrganizationGetRepo {
//   Future<Either<Failure, List<OrganizationEntities>>> get();
// }

abstract class OrganizationRepo {
  Future<Either<Failure, List<OrganizationEntities>>> get({OrganizationReadPrams? prams});
  Future<Either<Failure, OrganizationEntities>> create({required OrganiztionCreatePrams prams});
  Future<Either<Failure, OrganizationEntities>> update({required OrganizationUpdatePrams prams});
  Future<Either<Failure, bool>> delete({required OrganizationDeletePrams prams});

  Future<Map<String, dynamic>?> isOrganizationSaved();
  Future<void> organizationSaved(Map<String, dynamic> organization);
  Future<void> clearOrganization();
}

// // Create
// abstract class OrganizationCreateRepo {
//   Future<Either<Failure, OrganizationEntities>> call({required OrganiztionCreatePrams prams});
// }

// // Edit / Update
// abstract class OrganizationUpdateRepo {
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationUpdatePrams prams});
// }

// // Read
// abstract class OrganizationReadRepo {
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationReadPrams prams});
// }

// // Delete
// abstract class OrganizationDeleteRepo {
//   Future<Either<Failure, OrganizationEntities>> call({required OrganizationDeletePrams prams});
// }