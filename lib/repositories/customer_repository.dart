import 'package:blue_raycargo_id/core/config.dart';
import 'package:blue_raycargo_id/models/address_model.dart';
import 'package:dio/dio.dart';

class CustomerRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl!));

  Future getAddress(String token) async {
    try {
      final response = await _dio.get(
        '/api/blueray/customer/address',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.data is List) {
        return (response.data as List)
            .map((address) => Address.fromJson(address))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      return e.response?.data['message'] ?? 'Gagal mengambil data';
    } catch (e) {
      return e.toString;
    }
  }

  Future<String?> setPrimaryAddress(String token, int addressId) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/address/primary',
        options: Options(headers: {'Authorization': 'Token $token'}),
        data: {"address_id": addressId},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Gagal mengatur alamat utama';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> dellAddress(String token, int addressId) async {
    try {
      final response = await _dio.delete(
        '/api/blueray/customer/address/delete',
        options: Options(headers: {'Authorization': 'Token $token'}),
        data: {"address_id": addressId},
      );
      return response.data['action'];
    } on DioException {
      return false;
    } catch (e) {
      return false;
    }
  }

  // Tambah alamat baru
  Future<String?> addAddress(
    String token, {
    required String address,
    required String addressLabel,
    required String name,
    required String phoneNumber,
    required String email,
    required int provinceId,
    required int districtId,
    required int subDistrictId,
    required String postalCode,
    required double lat,
    required double long,
    required String addressMap,
    String? npwp,
    String? npwpFile,
  }) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/address',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          "address": address,
          "address_label": addressLabel,
          "name": name,
          "phone_number": phoneNumber,
          "email": email,
          "province_id": provinceId,
          "district_id": districtId,
          "sub_district_id": subDistrictId,
          "postal_code": postalCode,
          "lat": lat,
          "long": long,
          "address_map": addressMap,
          "npwp": npwp,
          "npwp_file": npwpFile,
        },
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Gagal menambahkan alamat';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> searchSubDistricts(
    String token,
    String query,
  ) async {
    try {
      final response = await _dio.get(
        '/api/blueray/address/subdistricts/search',
        options: Options(headers: {'Authorization': 'Token $token'}),
        queryParameters: {'q': query},
      );
      final data = response.data is Map ? response.data['data'] : response.data;
      if (data is List) {
        return data
            .where((subDistrict) => subDistrict != null)
            .map(
              (subDistrict) => {
                "address":
                    "${subDistrict['district']}, ${subDistrict['sub_district']}",
                "province": subDistrict['province'],
                "district": subDistrict['district'],
                "sub_district": subDistrict['sub_district'],
                "sub_district_code": subDistrict['sub_district_code'],
                "province_id": subDistrict['province_id'],
                "district_id": subDistrict['district_id'],
                "sub_district_id": subDistrict['sub_district_id'],
              },
            )
            .toList();
      } else {
        return [];
      }
    } on DioException {
      return [];
    } catch (e) {
      return [];
    }
  }
}
