import 'package:my_mobile_app/features/auth/domain/entities/user_entities.dart';

class UserResponseModel extends UserEntities {
  UserResponseModel(
      {required super.id,
      super.name,
      required super.email,
      super.imageUrl,
      super.phoneNumber,
      required super.userName,
      required super.isEmailVerified,
      super.uploadNewImage,
      super.imageAcceptedForToken});

  factory UserResponseModel.fromJson(json) {
    print("Inside user response converter");
    print(json);
    return UserResponseModel(
        id: json["_id"] ?? json["id"],
        name: json["name"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        phoneNumber: json["phoneNumber"],
        userName: json["userName"],
        isEmailVerified: json['isEmailVerified'],
        uploadNewImage: json['uploadNewImage'],
        imageAcceptedForToken : json['imageAcceptedForToken']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'userName': userName,
      'isEmailVerified': isEmailVerified,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'uploadNewImage': uploadNewImage,
      'imageAcceptedForToken' : imageAcceptedForToken
    };
  }
}
