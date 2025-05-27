class TokenModel {
  final String accessToken;
  final String refreshToken;

  TokenModel({required this.accessToken, required this.refreshToken});

  Map<String, String> toJson() {
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  factory TokenModel.fromJson(json) {
    return TokenModel(
        accessToken: json['accessToken'], refreshToken: json['refreshToken']);
  }
}
