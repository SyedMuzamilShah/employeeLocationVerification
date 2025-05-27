// String _ip = '192.168.1.126:3000';



class ServerUrl {
  static const String _ip = '192.168.109.126';

  static String replaceLocalhost(String url) {
    return url.replaceFirst('localhost', _ip);
  }


  static const String baseUrl = 'http://$_ip:3000/api/v1';

  
  static const String userRegisterRoute = '$baseUrl/employee/auth/register';
  static const String userLoginRoute = '$baseUrl/employee/auth/login';
  static const String userLogoutRoute = '$baseUrl/employee/auth/logout';
  static const String userRefreshToken = '$baseUrl/employee/auth/token';
  static const String userForgotRoute = '';
  static const String userChangePasswordRoute = '';
  static const String userGetProfileRoute = '$baseUrl/employee//auth/user/profile';

  static const String uploadImage = '$baseUrl/employee/upload-image';

  static const String tasksRead = '$baseUrl/employee/task/assign-task-read';
  static const String taskComplete = '$baseUrl/employee/task/completed';
}