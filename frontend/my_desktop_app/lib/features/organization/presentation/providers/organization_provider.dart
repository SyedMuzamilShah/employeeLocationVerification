import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/failure/failure.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/core/services/token_service.dart';
import 'package:my_desktop_app/features/organization/data/datasources/organization_datasources.dart';
import 'package:my_desktop_app/features/organization/data/datasources/organization_local_sources.dart';
import 'package:my_desktop_app/features/organization/data/models/request/organization_prams.dart';
import 'package:my_desktop_app/features/organization/data/repositories/organization_repo_impl.dart';
import 'package:my_desktop_app/features/organization/domain/entities/organization_entities.dart';
import 'package:my_desktop_app/features/organization/domain/usecases/organization_usecase.dart';

final organizationsLoadProvider =
    FutureProvider<List<OrganizationEntities>>((ref) async {
  final organizationNotifier = ref.watch(organizationProvider.notifier);
  return await organizationNotifier.read();
});

final organizationProvider =
    StateNotifierProvider<OrganizationNotifier, OrganizationState>((ref) {
  return OrganizationNotifier();
});

class OrganizationNotifier extends StateNotifier<OrganizationState> {
  OrganizationNotifier() : super(OrganizationState.initial());

  final OrganizationUsecase _useCase = OrganizationUseCaseImpl(
    repo: OrganizationRepoImpl(
      localSources: OrganizationLocalSourcesImpl(tokenService: TokenService()),
      dataSources: OrganizationDatasourcesImpl(services: ApiServices()),
    ),
  );

  // Clear all state including organizations
  void clearAll() {
    state = OrganizationState.initial();
  }

  // Clear only error and loading states
  void clearState() {
    state = state.copyWith(
      isLoading: false,
      errorMessage: null,
      errorList: null,
    );
  }

  Future<bool> create({required OrganiztionCreatePrams model}) async {
    try {
      state =
          state.copyWith(isLoading: true, errorMessage: null, errorList: null);
      final response = await _useCase.create(model);

      return response.fold(
        (failure) {
          if (failure is ValidationFailure) {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
              errorList: failure.errors,
            );
            return false;
          } else {
            state = state.copyWith(
              isLoading: false,
              errorMessage: failure.message,
            );
            return false;
          }
        },
        (organization) {
          state = state.copyWith(
            isLoading: false,
            organizations: [...state.organizations, organization],
            errorMessage: null,
            errorList: null,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unexpected error occurred: $e',
      );
      return false;
    }
  }

  Future<List<OrganizationEntities>> read(
      {OrganizationReadPrams? model}) async {
    // state =
    //     state.copyWith(isLoading: true, errorMessage: null, errorList: null);
    final response = await _useCase.get(prams: model);

    return response.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
        throw Exception(state.errorMessage);
      },
      (data) {
        state = state.copyWith(
          isLoading: false,
          organizations: data,
          errorMessage: null,
        );
        // return state.organizations;
        return data;
      },
    );
  }

  Future<void> update({required OrganizationUpdatePrams model}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _useCase.update(model);

      response.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (updatedOrg) {
          final updatedList = state.organizations
              .map((org) => org.id == updatedOrg.id ? updatedOrg : org)
              .toList();

          state = state.copyWith(
            isLoading: false,
            organizations: updatedList,
            errorMessage: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update organization: $e',
      );
    }
  }

  Future<void> delete(OrganizationDeletePrams model) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _useCase.delete(model);
      response.fold(
        (failure) => state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        ),
        (_) => state = state.copyWith(
          isLoading: false,
          organizations:
              state.organizations.where((org) => org.id != model.id).toList(),
          errorMessage: null,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete organization: $e',
      );
    }
  }

  Future<bool> isOrganizationSaved() async {
    try {
      // Check the organization is store in local database
      final data = await _useCase.isOrganizationSaved();

      print("yes i got result : $data that is map");
      // if not then return false
      if (data == null) return false;

      // create the query model
      final model = OrganizationReadPrams.fromJson(data);

      print("I am resquesting to get data from remote database");
      // get the organization data from database
      final response = await _useCase.get(prams: model);
      return response.fold(
        // if error come then falsr
        (err) => false,
        (succ) {
          print("success response is got : $succ");
          // if the organization LIST is not empty then
          if (succ.isNotEmpty) {
            print("succes is not empty");
            // change the state
            state = state.copyWith(selectedOrganization: succ.first);

            print('state may be update');
            print(state.selectedOrganization?.name);
            // return true
            return true;
          }

          // return false
          return false;
        },
      );
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to check saved organization: $e');
      return false;
    }
  }

  Future<void> clearOrganizationSaved () async {
    state = state.copyWith(selectedOrganization: null);
    await _useCase.clearOrganization();
  }

  Future<bool> organizationSaved(OrganizationEntities organization) async {
    try {
      // create the organization map which field want to store
      final Map<String, dynamic> org = {
        'id': organization.id,
        'organizationId': organization.organizationId
      };

      // save
      await _useCase.organizationSaved(org);

      // Select the selected one organization
      state = state.copyWith(selectedOrganization: organization);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to save organization: $e');
      return false;
    }
  }
}

class OrganizationState {
  final List<OrganizationEntities> organizations;
  final OrganizationEntities? selectedOrganization;
  final bool isLoading;
  final String? errorMessage;
  final List<dynamic>? errorList;

  OrganizationState({
    required this.organizations,
    this.selectedOrganization,
    required this.isLoading,
    this.errorMessage,
    this.errorList,
  });

  // Initial state
  factory OrganizationState.initial() => OrganizationState(
        organizations: [],
        isLoading: false,
        errorMessage: null,
        errorList: null,
      );

  OrganizationState copyWith({
    List<OrganizationEntities>? organizations,
    OrganizationEntities? selectedOrganization,
    bool? isLoading,
    String? errorMessage,
    List<dynamic>? errorList,
  }) {
    return OrganizationState(
      organizations: organizations ?? this.organizations,
      // errorMessage: errorMessage ?? this.errorMessage,
      // errorList: errorList ?? this.errorList,
      // selectedOrganization: selectedOrganization ?? this.selectedOrganization,
      selectedOrganization: selectedOrganization,
      isLoading: isLoading ?? this.isLoading,
      errorList: errorList,
      errorMessage: errorMessage,
    );
  }
}
