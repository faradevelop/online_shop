import 'package:flutter/cupertino.dart';
import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/model/user.dart';
import 'package:online_shop/data/source/profile_data_source.dart';

final profileRepository =
    ProfileRepository(ProfileRemoteDataSource(httpclient: httpClient));

abstract class IProfileRepository {
  Future<UserEntity> getProfile();

  Future<List<AddressEntity>> getAddresses();

  Future<List<ProvinceEntity>> getProvinces();

  Future<bool> addAddress(
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong});

  Future<bool> editAddress(int id,
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong});

  Future<bool> deleteAddress(int id);
}

class ProfileRepository extends IProfileRepository {
  final IProfileDataSource dataSource;
  static final ValueNotifier<List<AddressEntity>> addressListNotifier =
      ValueNotifier([]);

  ProfileRepository(this.dataSource);

  @override
  Future<UserEntity> getProfile() async {
    final user = await dataSource.getProfile();
    return user;
  }

  @override
  Future<List<AddressEntity>> getAddresses() async {
    final List<AddressEntity> addresses = await dataSource.getAddresses();
    addressListNotifier.value = addresses;
    return addresses;
  }

  @override
  Future<List<ProvinceEntity>> getProvinces() {
    return dataSource.getProvinces();
  }

  @override
  Future<bool> addAddress(
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong}) {
    return dataSource.addAddress(
        title: title,
        cityId: cityId,
        address: address,
        latlong: latlong,
        postalCode: postalCode);
  }

  @override
  Future<bool> editAddress(int id,
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong}) {
    return dataSource.editAddress(id,
        title: title,
        cityId: cityId,
        address: address,
        latlong: latlong,
        postalCode: postalCode);
  }

  @override
  Future<bool> deleteAddress(int id) {
    return dataSource.deleteAddress(id);
  }
}
