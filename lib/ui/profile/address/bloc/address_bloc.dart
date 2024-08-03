import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/repository/profile_repository.dart';

part 'address_event.dart';

part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final IProfileRepository profileRepository;

  AddressBloc(this.profileRepository) : super(AddressLoading()) {
    on<AddressEvent>((event, emit) async {
      if (event is AddressStarted) {
        emit(AddressLoading());
        try {
          final addresses = await profileRepository.getAddresses();
          final provinces = await profileRepository.getProvinces();
          emit(AddressSuccess(addresses, provinces));
        } catch (e) {
          emit(AddressError(exception: e is AppException ? e : AppException()));
        }
      }
      else if (event is UpdateAddressButtonClicked) {
        emit(UpdateAddressButtonLoading());
        try {
          if (event.id == null) {
            final res = await profileRepository.addAddress(
                title: event.title,
                cityId: event.cityID,
                address: event.address,
                postalCode: event.postalCode,
                latlong: event.latlong);
            if (res) {
              final addresses =await profileRepository.getAddresses();
              emit(UpdateAddressButtonSuccess(addresses));
            } else {
              emit(UpdateAddressButtonError(exception: AppException()));
            }
          } else {
            final res = await profileRepository.editAddress(event.id!,
                title: event.title,
                cityId: event.cityID,
                address: event.address,
                postalCode: event.postalCode,
                latlong: event.latlong);
            if (res) {
             final addresses =await profileRepository.getAddresses();
              emit(UpdateAddressButtonSuccess(addresses));
            } else {
              emit(UpdateAddressButtonError(exception: AppException()));
            }
          }
        } catch (e) {
          emit(UpdateAddressButtonError(
              exception: e is AppException ? e : AppException()));
        }
      } else if (event is UpdateAddressStarted) {
        emit(UpdateAddressLoading());
        try {
          final res = await profileRepository.getProvinces();
          emit(UpdateAddressSuccess(res));
        } catch (e) {}
  }
      else if (event is DeleteAddressButtonClicked) {
        try {
          if (state is AddressSuccess) {
            final successState = (state as AddressSuccess);
            final loadingItem = successState.address
                .firstWhere((element) => event.id == element.id);

            emit(AddressSuccess(successState.address, successState.provinces,
                loadingItem: loadingItem));
          }
          await Future.delayed(const Duration(milliseconds: 1000));

          await profileRepository.deleteAddress(event.id);
          final addresses = await profileRepository.getAddresses();

          if (state is AddressSuccess) {
            final successState = (state as AddressSuccess);
            successState.address.removeWhere(
                    (element) => event.id == element.id);

              // emit(CartSuccess(successState.cartItemResponse, null));
              emit(AddressSuccess(addresses, successState.provinces));

          }
        } catch (e) {

          //print(e.toString());
        }
      }
    });
  }
}
