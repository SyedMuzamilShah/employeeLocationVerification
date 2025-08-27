class OrganizationReadPrams {
  final String? id;
  final String? organizationId;

  OrganizationReadPrams({this.id, this.organizationId});

  Map<String, dynamic> toJson() {
    return {'id': id, 'organizationId': organizationId};
  }

  factory OrganizationReadPrams.fromJson(json) {
    return OrganizationReadPrams(
        id: json['id'], organizationId: json['organizationId']);
  }
}

class OrganiztionCreatePrams {
  final String name;
  final String email;
  final String phoneNumber;
  final String? website;
  final String address;

  OrganiztionCreatePrams({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.website,
    required this.address,
  });
  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
    };

    if (website != null && website!.trim().isNotEmpty) {
      data['website'] = website!;
    }

    return data;
  }
}

class OrganizationUpdatePrams {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String website;
  final String address;

  OrganizationUpdatePrams({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.website,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'organizationId': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'website': website,
      'address': address,
    };
  }
}

class OrganizationDeletePrams {
  final String? id;
  final String? organizationId;

  OrganizationDeletePrams({this.id, this.organizationId}) {
    if (id == null && organizationId == null) {
      throw Exception("Either 'id' or 'organizationId' is required");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'organizationId': organizationId,
      'id': id,
    };
  }
}
