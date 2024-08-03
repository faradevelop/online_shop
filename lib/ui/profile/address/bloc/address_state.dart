part of 'address_bloc.dart';

@immutable
sealed class AddressState {
  const AddressState();
}

class AddressLoading extends AddressState {}

class AddressSuccess extends AddressState {
  final List<AddressEntity> address;
  final List<ProvinceEntity> provinces;
  final AddressEntity? loadingItem;

  const AddressSuccess(this.address, this.provinces, {this.loadingItem});
}

/*class AddressEmpty extends AddressState {}*/

/*
class AddressRefreshSuccess extends AddressState {
  final List<AddressEntity> address;
  final List<ProvinceEntity> provinces;

  const AddressRefreshSuccess(this.address, this.provinces);
}

*/

final class AddressError extends AddressState {
  final AppException exception;

  const AddressError({required this.exception});
}

class UpdateAddressSuccess extends AddressState {
  final List<ProvinceEntity> provinces;

  const UpdateAddressSuccess(this.provinces);
}

class UpdateAddressLoading extends AddressState {}


class UpdateAddressButtonSuccess extends AddressState {
  final List<AddressEntity> address;

  const UpdateAddressButtonSuccess(this.address);
}

class UpdateAddressButtonLoading extends AddressState {}

class UpdateAddressButtonError extends AddressState {
  final AppException exception;

  const UpdateAddressButtonError({required this.exception});


}
