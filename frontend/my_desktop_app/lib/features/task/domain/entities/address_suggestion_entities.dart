class AddressSuggestionEntities {
  final String? name;
  final String? country;
  final String formatted;
  final String? state;
  final double lat;
  final double lon;
  final String? city;

  AddressSuggestionEntities({
    required this.name,
    required this.country,
    required this.formatted,
    required this.state,
    required this.lat,
    required this.city,
    required this.lon,
  });

  factory AddressSuggestionEntities.fromMap(Map<String, dynamic> json) {
    final props = json['properties'];
    final coords = json['geometry']['coordinates'];

    return AddressSuggestionEntities(
      name: props['name'],
      country: props['country'],
      formatted: props['formatted'],
      state: props['state'],
      city: props['city'],
      lat: coords[1],
      lon: coords[0],
    );
  }
}
