class RegisterParams {
  final String userName;
  final String organizationId;
  final String? name;
  final String email;
  final String password;
  final String? phoneNumber;

  RegisterParams({
    required this.userName,
    required this.organizationId,
    required this.email,
    required this.password,
    this.name,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {

    
    return {
      'userName': userName,
      'organizationId' : organizationId,
      'email': email,
      'password': password,
      if (name != null) 'name': phoneNumber,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}