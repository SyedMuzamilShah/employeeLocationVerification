import 'package:my_desktop_app/features/task/domain/entities/address_suggestion_entities.dart';

class AddressSuggestionResponse extends AddressSuggestionEntities {
  AddressSuggestionResponse(
      {required super.name,
      required super.country,
      required super.formatted,
      required super.state,
      required super.lat,
      required super.city,
      required super.lon});

  factory AddressSuggestionResponse.fromMap(Map<String, dynamic> json) {
    final props = json['properties'];
    final coords = json['coordinates'];
    return AddressSuggestionResponse(
      name: props['name'],
      country: props['country'],
      formatted: props['formatted'],
      state: props['state'],
      city: props['city'],

      lat: coords['latitude'],
      lon: coords['longitude'],
    );
  }
}
