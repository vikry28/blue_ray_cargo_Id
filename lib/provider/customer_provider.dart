import 'package:blue_raycargo_id/core/preferences.dart';
import 'package:blue_raycargo_id/models/address_model.dart';
import 'package:blue_raycargo_id/repositories/customer_repository.dart';
import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  final CustomerRepository _customerRepository = CustomerRepository();
  String? token;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Address> _addresses = [];
  List<Address> get addresses => _addresses;
  String? get _token => token;

  Future<void> _loadToken() async {
    token = Preferences.getToken();
    notifyListeners();
  }

  Future<void> getAddress() async {
    await _loadToken();
    if (_token == null || _token!.isEmpty) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      List<Address> fetchedAddresses = await _customerRepository.getAddress(
        _token!,
      );
      _addresses = fetchedAddresses;
      debugPrint('Data Address berhasil diambil: $_addresses');
    } catch (e) {
      debugPrint('Error fetching addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> setPrimaryAddress(int addressId) async {
    await _loadToken();

    _isLoading = true;
    notifyListeners();

    String? massage = await _customerRepository.setPrimaryAddress(
      _token!,
      addressId,
    );
    _isLoading = false;
    notifyListeners();
    return massage;
  }

  Future<bool> deleteAddress(int addressId) async {
    await _loadToken();

    _isLoading = true;
    notifyListeners();

    bool isDeleted = await _customerRepository.dellAddress(_token!, addressId);
    _isLoading = false;
    notifyListeners();
    return isDeleted ? true : false;
  }

  Future<List<Map<String, dynamic>>> searchSubDistricts(String query) async {
    await _loadToken();

    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> subDistricts = await _customerRepository
          .searchSubDistricts(_token!, query);
      return subDistricts;
    } catch (e) {
      debugPrint('Error searching sub-districts: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<String?> addAddress(AddressModel address) async {
  //   await _loadToken();
  //   if (_token == null || _token!.isEmpty) {
  //     return 'User not authenticated';
  //   }

  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     String? message = await _customerRepository.addAddress(
  //       _token!,
  //       address: address.address,
  //       addressLabel: address.name,
  //       name: address.name,
  //       phoneNumber: address.phoneNumber,
  //       email: address.email ?? '',
  //       provinceId: address.provinceId ?? 0,
  //       districtId: address.districtId ?? 0,
  //       subDistrictId: address.subDistrictId ?? 0,
  //       postalCode: address.postalCode,
  //       lat: address.latitude ?? 0.0,
  //       long: address.longitude ?? 0.0,
  //       addressMap: address.addressMap ?? '',
  //     );
  //     if (message == null) {
  //       _addresses.add(address);
  //       notifyListeners();
  //     }
  //     _isLoading = false;
  //     return message;
  //   } catch (e) {
  //     debugPrint('Error adding address: $e');
  //     _isLoading = false;
  //     return 'Failed to add address';
  //   } finally {
  //     notifyListeners();
  //   }
  // }
}
