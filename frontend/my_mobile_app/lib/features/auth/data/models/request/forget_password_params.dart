class ForgetPasswordParams {
  String email;

  ForgetPasswordParams({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}