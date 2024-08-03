class AddressEntity {
  int? id;
  String? title;
  String? address;
  int? postalCode;
  String? latlong;
  String? city;
  String? province;
  int? cityId;
  int? provinceId;

  AddressEntity(
      {this.id,
      this.title,
      this.address,
      this.postalCode,
      this.latlong,
      this.city,
      this.province,
      this.cityId,
      this.provinceId});

  AddressEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    address = json['address'];
    postalCode = json['postal_code'];
    latlong = json['latlong'];
    city = json['city'];
    province = json['province'];
    cityId = json['city_id'];
    provinceId = json['province_id'];
  }
}

class ProvinceEntity {
  int? id;
  String? name;
  List<CityEntity>? cities;

  ProvinceEntity({this.id, this.name, this.cities});

  ProvinceEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['cities'] != null) {
      cities = <CityEntity>[];
      json['cities'].forEach((v) {
        cities!.add( CityEntity.fromJson(v));
      });
    }
  }
}

class CityEntity {
  int? id;
  String? name;
  int? provinceId;

  CityEntity({this.id, this.name, this.provinceId});

  CityEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    provinceId = json['province_id'];
  }
}
