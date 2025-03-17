import 'package:flutter/material.dart';
import '../core/preferences.dart';
import '../repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  String? _token;
  bool _isLoading = false;

  String? get token => _token;
  bool get isLoading => _isLoading;
  bool _isAutentikasi = false;
  bool get isAutentikasi => _isAutentikasi;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await Preferences.init();
    _token = Preferences.getToken();
    _isAutentikasi = _token != null; // Set autentikasi jika token ada
    notifyListeners();
  }

  Future<String?> registerMini(String email) async {
    _isLoading = true;
    notifyListeners();

    String? message = await _authRepository.registerminicheck(email);
    _isLoading = false;
    notifyListeners();
    return message;
  }

  Future<String?> verifyEmail(String email, String code) async {
    _isLoading = true;
    notifyListeners();

    String? massage = await _authRepository.verifyEmail(email, code);
    _isLoading = false;
    notifyListeners();
    return massage;
  }

  Future<String?> resendVerificationCode(String email) async {
    _isLoading = true;
    notifyListeners();

    String? massage = await _authRepository.resendCode(email);
    _isLoading = false;
    notifyListeners();
    return massage;
  }

  Future<String?> register(
    String email,
    String firstname,
    String lastname,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    String? message = await _authRepository.registerMandatory(
      email,
      firstname,
      lastname,
      password,
    );

    _isLoading = false;
    notifyListeners();
    return message;
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    String? message = await _authRepository.login(email, password);
    if (message != null) {
      _token = message;
      await Preferences.saveToken(message);
      _isAutentikasi = true;
    }

    _isLoading = false;
    notifyListeners();
    return message;
  }

  Future<String?> logout() async {
    _isLoading = true;
    notifyListeners();

    String? message = await _authRepository.logout(_token!);
    _token = null;
    _isAutentikasi = false;
    await Preferences.removeToken();

    _isLoading = false;
    notifyListeners();
    return message;
  }
}
