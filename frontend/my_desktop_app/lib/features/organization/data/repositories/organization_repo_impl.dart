import 'package:fpdart/fpdart.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/features/organization/data/datasources/organization_datasources.dart';
import 'package:my_desktop_app/features/organization/data/datasources/organization_local_sources.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/data/models/response/organization_response.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';
import 'package:my_desktop_app/features/organization/domain/repositories/organization_repo.dart';

class OrganizationRepoImpl extends OrganizationRepo {
  final OrganizationDatasources _dataSources;
  final OrganizationLocalSources _localSources;

  OrganizationRepoImpl({required OrganizationDatasources dataSources, required OrganizationLocalSources localSources})
      : _dataSources = dataSources,
        _localSources = localSources;

  @override
  Future<Either<Failure, OrganizationEntities>> create(
      {required OrganiztionCreatePrams prams}) async {
    final response = await _dataSources.create(prmas: prams.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) => Right(OrganizationResponseModel.fromJson(succ['data'])),
    );
  }

  @override
  Future<Either<Failure, bool>> delete(
      {required OrganizationDeletePrams prams}) async {
    // final response = await _dataSources.delete(prams: prams);
    final response = await _dataSources.delete(prams: prams.toJson());
    return response.fold((err) => Left(err),
        (succ){
          return Right(true);
        });
  }

  @override
  Future<Either<Failure, List<OrganizationEntities>>> get(
      {OrganizationReadPrams? prams}) async {
    final response = await _dataSources.get(
      prams: prams?.toJson()
    );

    return response.fold((err) => Left(err), (succ) {
      List data = succ['data']['organizations'];
      
      List<OrganizationEntities> organization =
          data.map((e) => OrganizationResponseModel.fromJson(e)).toList();
      return Right(organization);
    });
  }

  @override
  Future<Either<Failure, OrganizationEntities>> update(
      {required OrganizationUpdatePrams prams}) async {
    final response = await _dataSources.update(prams: prams.toJson());
    return response.fold(
      (err) => Left(err),
      (succ) => Right(OrganizationResponseModel.fromJson(succ['data'])),
    );
  }
  
  @override
  Future<Map<String, dynamic>?> isOrganizationSaved() async {
    return await _localSources.getOrganization();
  }
  
  @override
  Future<void> organizationSaved(Map<String, dynamic> organization) async {
    await _localSources.cacheOrganization(organization);
  }
  
  @override
  Future<void> clearOrganization() async {
    await _localSources.clearLocalOrganization();
  }
}
