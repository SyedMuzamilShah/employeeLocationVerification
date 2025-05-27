class TaskVerifiedParams {
  final String taskId;
  // final List<EmployeesVerified> employeesId;
  final List<String> employeesId;

  TaskVerifiedParams({required this.taskId, required this.employeesId});

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId, 
      // 'employeesId': employeesId.map((e)=> e.toJson()).toList()};
      'employeesId': employeesId
    };
  }
}

// class EmployeesVerified {
//   final String employeeId;

//   const EmployeesVerified({
//     required this.employeeId,
//   });

//   Map<String, dynamic> toJson() => {
//         'employeeId': employeeId,
//       };

//   EmployeesVerified copyWith({
//     String? employeeId,
//   }) {
//     return EmployeesVerified(
//       employeeId: employeeId ?? this.employeeId,
//     );
//   }
// }