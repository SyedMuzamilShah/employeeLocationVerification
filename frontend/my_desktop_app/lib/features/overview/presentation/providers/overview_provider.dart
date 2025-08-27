import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/core/services/api_services.dart';
import 'package:my_desktop_app/features/organization/presentation/providers/organization_provider.dart';
import 'package:my_desktop_app/features/overview/data/datasources/statistics_datasources.dart';
import 'package:my_desktop_app/features/overview/data/models/request/employee_role_statistics.dart';
import 'package:my_desktop_app/features/overview/data/models/request/task_statistics.dart';
import 'package:my_desktop_app/features/overview/data/repositories/statistics_repo_impl.dart';
import 'package:my_desktop_app/features/overview/domain/usecases/overview_usecase.dart';



final loadTaskStatisticsProvider = FutureProvider.autoDispose((ref) async {
  final String? organizationId =
      ref.read(organizationProvider).selectedOrganization?.id;

      print(organizationId);
      print("testing of statistic");

  StatisticsUseCase useCase = StatisticsUseCase(StatisticsRepoImpl(
      StatisticsRemoteDataSourceImpl(apiServices: ApiServices())));

  if (organizationId == null) {
    throw Exception('No organization selected');
  }

  TaskStatisticsParams params =
      TaskStatisticsParams(organizationId: organizationId);
  // Call your repository/API
  final taskStatistics = await useCase.getTaskStatistics(params);
  return taskStatistics.fold(
      (err) => throw Exception(err.message), (succ) => succ);
});

final loadEmployeeRollStatisticsProvider =
    FutureProvider.autoDispose((ref) async {
  final String? organizationId =
      ref.read(organizationProvider).selectedOrganization?.id;

  StatisticsUseCase useCase = StatisticsUseCase(StatisticsRepoImpl(
      StatisticsRemoteDataSourceImpl(apiServices: ApiServices())));

  if (organizationId == null) {
    throw Exception('No organization selected');
  }

  EmployeeRoleStatisticsParams params =
      EmployeeRoleStatisticsParams(organizationId: organizationId);
  // Call your repository/API
  final taskStatistics = await useCase.getEmployeeRoleStatistics(params);
  return taskStatistics.fold(
      (err) => throw Exception(err.message), (succ) => succ);
});








// Assuming OverViewData is defined

// class OverViewNotifier extends StateNotifier<AsyncValue<OverViewData>> {
//   final Ref ref;

//   OverViewNotifier(this.ref) : super(const AsyncValue.loading()) {
//     fetchOverViewData();
//   }

//   Future<void> fetchOverViewData() async {
//     try {
//       final organizations = await ref.read(organizationProvider.future);

//       // ... fetch analytics data if needed

//       state = AsyncValue.data(OverViewData(
//         organizations: organizations ?? [],
//         // ... analytics data
//       ));
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }

//   // Add methods to update the OverView data (e.g., refresh, update analytics)
//   Future<void> refreshOrganizations() async {
//     //ref.invalidate(organizationProvider);
//     //fetchOverViewData(); // or update only organization part.
//     try {
//       final organizations = await ref.read(organizationProvider.future);
//       state = state
//           .whenData((value) => value.copyWith(organizations: organizations));
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }
//   //add copyWith method to OverViewData
// }

// class OverViewData {
//   final List<OrganizationEntities> organizations;
//   // ... other data

//   OverViewData({required this.organizations});

//   OverViewData copyWith(
//       {List<OrganizationEntities>? organizations, UserEntities? user}) {
//     return OverViewData(
//         organizations: organizations ?? this.organizations,);
//   }
// }

// final overviewProvider =
//     StateNotifierProvider<OverViewNotifier, AsyncValue<OverViewData>>((ref) {
//   return OverViewNotifier(ref);
// });
// final overviewProvider = FutureProvider((ref){
//   return ref.read(organizationProvider.future);
// });