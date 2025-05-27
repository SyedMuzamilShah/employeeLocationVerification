import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_desktop_app/features/employee/data/models/request/employee_prams.dart';

final employeeReadParamsProvider = StateProvider<EmployeeReadParams>((ref){
  return EmployeeReadParams();
});