// String _ip = '192.168.1.126:3000';

class ServerUrl {
  static const String _ip = '192.168.100.8';
  // static const String _ip = '10.82.215.126';

  static String replaceLocalhost(String url) {
    return url.replaceFirst('localhost', _ip);
  }

  static const String baseUrl = 'http://$_ip:3000/api/v1';
 
  // static const String _host =
  //     'b3c3-2402-ad80-8b-5e50-a84e-f3fe-21eb-741b.ngrok-free.app';

  // static String replaceLocalhost(String url) {
  //   return url.replaceFirst('localhost', _host);
  // }

  // static const String baseUrl = 'https://$_host/api/v1';

  static const String userRegisterRoute = '$baseUrl/employee/auth/register';
  static const String userLoginRoute = '$baseUrl/employee/auth/login';
  static const String userLogoutRoute = '$baseUrl/employee/auth/logout';
  static const String userRefreshToken = '$baseUrl/employee/auth/token';
  static const String userForgotRoute = '';
  static const String userChangePasswordRoute = '$baseUrl/employee/auth/change-password';
  static const String userGetProfileRoute =
      '$baseUrl/employee//auth/user/profile';

  static const String uploadImage = '$baseUrl/employee/upload-image';

  static const String tasksRead = '$baseUrl/employee/task/assign-task-read';
  static const String taskComplete = '$baseUrl/employee/task/completed';
  static const String taskCompleteCheckOut = '$baseUrl/employee/task/completed-checkout';
}
