import 'package:my_desktop_app/core/services/token_service.dart';
import 'package:my_desktop_app/core/errors/exceptions.dart';

abstract class OrganizationLocalSources {
  Future<void> clearOrganization();
  Future<void> cacheOrganization(Map<String, dynamic> organization);
  Future<Map<String, dynamic>?> getOrganization();
}

class OrganizationLocalSourcesImpl implements OrganizationLocalSources {
  final TokenService _tokenService;

  OrganizationLocalSourcesImpl({required TokenService tokenService})
      : _tokenService = tokenService;

  @override
  Future<void> cacheOrganization(Map<String, dynamic> organization) async {
    try {
      await _tokenService.setOrganization(organization);
    } catch (e) {
      throw CacheException('Failed to cache token: ${e.toString()}');
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getOrganization() async {
    return _tokenService.organization;
  }
  
  @override
  Future<void> clearOrganization() async {
    await _tokenService.clearOrganization();
    // TODO: implement clearOrganization
    throw UnimplementedError();
  }
}
