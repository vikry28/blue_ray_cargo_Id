class DistrictModel {
  final String address;
  final String province;
  final String district;
  final String subDistrict;
  final String subDistrictCode;
  final int provinceId;
  final int districtId;
  final int subDistrictId;

  DistrictModel({
    required this.address,
    required this.province,
    required this.district,
    required this.subDistrict,
    required this.subDistrictCode,
    required this.provinceId,
    required this.districtId,
    required this.subDistrictId,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      address: json['address'],
      province: json['province'],
      district: json['district'],
      subDistrict: json['sub_district'],
      subDistrictCode: json['sub_district_code'],
      provinceId: json['province_id'],
      districtId: json['district_id'],
      subDistrictId: json['sub_district_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'province': province,
      'district': district,
      'sub_district': subDistrict,
      'sub_district_code': subDistrictCode,
      'province_id': provinceId,
      'district_id': districtId,
      'sub_district_id': subDistrictId,
    };
  }
}
