import 'package:dio/dio.dart';
import 'package:online_shop/common/http_response_validator.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/model/user.dart';

abstract class IProfileDataSource {
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

class ProfileRemoteDataSource with HttpResponseValidator implements IProfileDataSource {
  final Dio httpclient;

  ProfileRemoteDataSource({required this.httpclient});


  @override
  Future<UserEntity> getProfile() async {
    final res = await httpclient.get("/profile");
    validateResponse(res);

    return UserEntity.fromJson(res.data['data']);
  }


  @override
  Future<List<AddressEntity>> getAddresses() async {
    final res = await httpclient.get("/address");
    validateResponse(res);
    final addresses = <AddressEntity>[];
    for (var element in (res.data['data'] as List)) {
      addresses.add(AddressEntity.fromJson(element));
    }
    return addresses;
  }


  @override
  Future<List<ProvinceEntity>> getProvinces() async {
    final res = await httpclient.get("/provinces");

    validateResponse(res);
    final provinces = <ProvinceEntity>[];
    for (var element in (res.data['data'] as List)) {
      provinces.add(ProvinceEntity.fromJson(element));
    }
    return provinces;
  }

  @override
  Future<bool> addAddress(
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong}) async {
    var res = await httpclient.post("/address", data: {
      "title": title,
      "city_id": cityId.toString(),
      "address": address,
      "latlong": latlong,
      "postal_code": postalCode
    });
    return res.statusCode == 200;
  }

  @override
  Future<bool> editAddress(int id,
      {required String title,
      required int cityId,
      required String address,
      String? postalCode,
      String? latlong}) async {
    var res = await httpclient.put("/address/$id", data: {
      "title": title,
      "city_id": cityId.toString(),
      "address": address,
      "latlong": latlong,
      "postal_code": postalCode
    });
    return res.statusCode == 200;
  }

  @override
  Future<bool> deleteAddress(int id) async {
    var res = await httpclient.delete("/address/$id");
    return res.statusCode == 200;
  }
}
