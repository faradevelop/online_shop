import 'package:online_shop/data/model/address.dart';

/*class AddressResponse {
  List<AddressEntity>? addresses;

  AddressResponse({this.addresses});

  AddressResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      addresses = <AddressEntity>[];
      json['data'].forEach((v) {
        addresses!.add(AddressEntity.fromJson(v));
      });
    }
  }
}*/

class ProvinceResponse {
  List<ProvinceEntity>? provinces;

  ProvinceResponse({this.provinces});

  ProvinceResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      provinces = <ProvinceEntity>[];
      json['data'].forEach((v) {
        provinces!.add(ProvinceEntity.fromJson(v));
      });
    }
  }
}
