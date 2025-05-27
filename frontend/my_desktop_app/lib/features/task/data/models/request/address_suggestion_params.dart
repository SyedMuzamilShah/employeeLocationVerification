import 'package:equatable/equatable.dart';

class AddressSuggestionParams extends Equatable {
  final String address;

  const AddressSuggestionParams({required this.address});

  Map<String, dynamic> toMap() {
    return {
      'address': address,
    };
  }

  @override
  List<Object?> get props => [];
}