// String _ip = '192.168.1.126:3000';



class ServerUrl {
  static const String _ip = 'localhost';
  static const String baseUrl = 'http://$_ip:3000/api/v1';

  
  static const String userRegisterRoute = '$baseUrl/admin/auth/register';
  static const String userLoginRoute = '$baseUrl/admin/auth/login';
  static const String userLogoutRoute = '$baseUrl/admin/auth/logout';
  static const String userRefreshToken = '$baseUrl/admin/auth/token';
  static const String userForgotRoute = '';
  static const String userChangePasswordRoute = '';
  static const String userGetProfileRoute = '';


  static const String getAddressSuggestion = '$baseUrl/admin/address/get-suggestions';
 
  
  static const String employeeCreateRoute = '$baseUrl/admin/employee/create';
  static const String employeeDeleteRoute = '$baseUrl/admin/employee/delete';
  static const String employeeWholeDataUpdateRoute = '$baseUrl/admin/employee/update-data';
  static const String employeeGetRoute = '$baseUrl/admin/employee/get';
  static const String employeeStatusChangeRoute = '$baseUrl/admin/employee/status-change';
  static const String employeePictureAllowForProcessing = '$baseUrl/admin/employee/allow-picture';
  static const String employeePictureRejectForProcessing = '$baseUrl/admin/employee/reject-picture';

  static const String employeeLoginRoute = '$baseUrl/admin/auth/login';
  static const String employeeLogoutRoute = '$baseUrl/admin/auth/logout';
  static const String employeeRefreshToken = '$baseUrl/admin/auth/token';




  static const String userGetOrganization = '$baseUrl/admin/organization/get';
  static const String userCreateOrganization = '$baseUrl/admin/organization/register';
  static const String userUpdateOrganization = '$baseUrl/admin/organization/get';
  static const String userDeleteOrganization = '$baseUrl/admin/organization/delete';

  static const String taskRead = '$baseUrl/admin/task/get';
  static const String taskDetailGet = '$baseUrl/admin/task/assigned-detail';
  static const String taskAssign = '$baseUrl/admin/task/assign';
  static const String taskStatusChange = '$baseUrl/admin/task/status-change';
  static const String taskVerified = '$baseUrl/admin/task/verified';
  static const String taskDeassign = '$baseUrl/admin/task/deassign';
  static const String taskCreate = '$baseUrl/admin/task/create';
  static const String taskUpdate = '$baseUrl/admin/task/update';
  static const String taskDelete = '$baseUrl/admin/task/delete';


  // Statistics
  static const String employeeRoleStatistics = '$baseUrl/admin/statistics/employee-role';
  static const String taskStatistics = '$baseUrl/admin/statistics/task';

}