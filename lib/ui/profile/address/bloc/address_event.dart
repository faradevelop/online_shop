part of 'address_bloc.dart';

@immutable
sealed class AddressEvent {}

class AddressStarted extends AddressEvent {}

class UpdateAddressStarted extends AddressEvent {}

class DeleteAddressButtonClicked extends AddressEvent {
  final int id;

  DeleteAddressButtonClicked(this.id);
}

class UpdateAddressButtonClicked extends AddressEvent {
  final int? id;
  final String title;
  final int cityID;
  final String address;
  final String? postalCode;
  final String? latlong;

  UpdateAddressButtonClicked(
      {this.id,
      required this.title,
      required this.cityID,
      required this.address,
      this.postalCode,
      this.latlong});
}
