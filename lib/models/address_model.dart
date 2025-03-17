import 'dart:convert';

class Address {
  final int addressId;
  final int provinceId;
  final String provinceName;
  final int districtId;
  final String districtName;
  final int subDistrictId;
  final String subDistrictName;
  final String cityCode;
  final String? npwpFile;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String service;
  final String addressType;
  final String? addressLabel;
  final String name;
  final String countryName;
  final String address;
  final String postalCode;
  final double? longitude;
  final double? latitude;
  final String? addressMap;
  final String? email;
  final String phoneNumber;
  final String? phoneNumber2;
  final String? npwp;
  final bool isPrimary;
  final String? note;
  final int customer;
  final int province;
  final int district;
  final int subDistrict;
  final int? country;

  Address({
    required this.addressId,
    required this.provinceId,
    required this.provinceName,
    required this.districtId,
    required this.districtName,
    required this.subDistrictId,
    required this.subDistrictName,
    required this.cityCode,
    this.npwpFile,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.service,
    required this.addressType,
    this.addressLabel,
    required this.name,
    required this.countryName,
    required this.address,
    required this.postalCode,
    this.longitude,
    this.latitude,
    this.addressMap,
    this.email,
    required this.phoneNumber,
    this.phoneNumber2,
    this.npwp,
    required this.isPrimary,
    this.note,
    required this.customer,
    required this.province,
    required this.district,
    required this.subDistrict,
    this.country,
  });

  // Convert JSON to Model
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addressId: json["address_id"],
    provinceId: json["province_id"],
    provinceName: json["province_name"],
    districtId: json["district_id"],
    districtName: json["district_name"],
    subDistrictId: json["sub_district_id"],
    subDistrictName: json["sub_district_name"],
    cityCode: json["city_code"],
    npwpFile: json["npwp_file"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt:
        json["deleted_at"] != null ? DateTime.parse(json["deleted_at"]) : null,
    service: json["service"],
    addressType: json["address_type"],
    addressLabel: json["address_label"],
    name: json["name"],
    countryName: json["country_name"],
    address: json["address"],
    postalCode: json["postal_code"],
    longitude: json["long"]?.toDouble(),
    latitude: json["lat"]?.toDouble(),
    addressMap: json["address_map"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    phoneNumber2: json["phone_number_2"],
    npwp: json["npwp"],
    isPrimary: json["is_primary"],
    note: json["note"],
    customer: json["customer"],
    province: json["province"],
    district: json["district"],
    subDistrict: json["sub_district"],
    country: json["country"],
  );

  // Convert Model to JSON
  Map<String, dynamic> toJson() => {
    "address_id": addressId,
    "province_id": provinceId,
    "province_name": provinceName,
    "district_id": districtId,
    "district_name": districtName,
    "sub_district_id": subDistrictId,
    "sub_district_name": subDistrictName,
    "city_code": cityCode,
    "npwp_file": npwpFile,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt?.toIso8601String(),
    "service": service,
    "address_type": addressType,
    "address_label": addressLabel,
    "name": name,
    "country_name": countryName,
    "address": address,
    "postal_code": postalCode,
    "long": longitude,
    "lat": latitude,
    "address_map": addressMap,
    "email": email,
    "phone_number": phoneNumber,
    "phone_number_2": phoneNumber2,
    "npwp": npwp,
    "is_primary": isPrimary,
    "note": note,
    "customer": customer,
    "province": province,
    "district": district,
    "sub_district": subDistrict,
    "country": country,
  };

  // Convert List of JSON to List<Address>
  static List<Address> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Address.fromJson(json)).toList();
  }
}
