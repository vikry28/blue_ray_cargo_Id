import 'package:dio/dio.dart';
import '../core/config.dart';

class AuthRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl!,
      headers: {'AccessToken': AppConfig.accessToken!},
    ),
  );
  final Dio dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl!));

  // Check email aktif/inaktif
  Future<String?> registerminicheck(String email) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/register/mini',
        data: {'user_id': email},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ??
            'Customer dengan email/blueray/no telp $email sudah terdaftar melalui Blueray Cargo';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Verifikasi email aktif
  Future<String?> verifyEmail(String email, String code) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/register/verify-code',
        data: {'user_id': email, 'code': code},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Kode verifikasi salah';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Resend verification code
  Future<String?> resendCode(String email) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/register/resend-code',
        data: {'user_id': email},
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Gagal mengirim ulang kode';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Lengkapi data registrasi
  Future<String?> registerMandatory(
    String email,
    String firstname,
    String lastname,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/register/mandatory',
        data: {
          "user_id": email,
          "first_name": firstname,
          "last_name": lastname,
          "password": password,
        },
      );
      return response.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Gagal mendaftar';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Login
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/login',
        data: {'user_id': email, 'password': password},
      );
      return response.data['token'];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data['message'] ?? 'Gagal login';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<String?> logout(String token) async {
    try {
      final response = await _dio.post(
        '/api/blueray/customer/logout',
        options: Options(headers: {'Authorization': 'Token $token'}),
      );
      if (response.statusCode == 204) {
        return 'Logout berhasil';
      }
      return 'Gagal logout';
    } catch (e) {
      return e.toString();
    }
  }
}
