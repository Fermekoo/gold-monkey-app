import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:gold_monkey/data/models/deposit_model.dart';
import 'package:gold_monkey/data/models/login_model.dart';
import 'package:gold_monkey/data/models/register_model.dart';
import 'package:gold_monkey/data/models/user_model.dart';
import 'package:gold_monkey/data/models/wallet_model.dart';
import 'package:path_provider/path_provider.dart';

class AuthService {
  final Dio _dio = Dio();
  PersistCookieJar? _cookieJar;

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String get baseUrl {
    return "https://gold.inspirapustaka.com";
  }

  Future<void> init() async {
    if (_cookieJar != null) return;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    _cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/"),
    );

    _dio.interceptors.add(CookieManager(_cookieJar!));

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<bool> register(RegisterRequest request) async {
    await init();
    try {
      final response = await _dio.post(
        '$baseUrl/v1/register',
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("register failed: ${e.toString()}");
    }
  }

  Future<bool> login(LoginRequest request) async {
    await init();
    try {
      final response = await _dio.post(
        '$baseUrl/v1/login',
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      if (response.statusCode == 200) {
        final List<String>? rawCookies = response.headers['set-cookie'];
        if (rawCookies != null) {
          // 1. Parsing string menjadi Object Cookie
          final List<Cookie> cookies = rawCookies.map((str) {
            return Cookie.fromSetCookieValue(str);
          }).toList();

          // 2. Tentukan URI Host
          final uri = Uri.parse(baseUrl);
          
          await _cookieJar?.saveFromResponse(uri, cookies);

        }
        return true;
      }
      return false;

    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("login failed: ${e.toString()}");
    }
  }

  Future<UserModel> getProfile() async {
    await init();
    try {
      final response = await _dio.get('$baseUrl/v1/profile');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DashboardData> getDashboard() async {
    await init();
    try {
      // Ganti endpoint sesuai backend Anda
      final response = await _dio.get('$baseUrl/v1/dashboard');
      print("🔍 RAW DASHBOARD JSON: ${response.data}");
      return DashboardData.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<DepositChannel>> getDepositChannels() async {
    await init();
    try {
      // Sesuaikan endpoint backend Anda
      final response = await _dio.get('$baseUrl/v1/deposit/channels');
      
      // Ambil wrapper 'data' sesuai kontrak JSON
      final List<dynamic> list = response.data['data'] ?? [];
      
      return list.map((e) => DepositChannel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // 2. GET ADDRESS (Mocking/Real)
  // Karena Anda belum memberi kontrak API address, saya buat logic:
  // Jika backend sudah siap, uncomment bagian API call.
  // Untuk sekarang, kita return dummy address agar UI bisa ditest.
  Future<DepositAddress> getDepositAddress(String channelId) async {
    await init();
    
    // --- OPSI A: JIKA BACKEND SUDAH ADA ---
    /*
    try {
      final response = await _dio.get(
        '$baseUrl/v1/deposit/address',
        queryParameters: {'id': channelId},
      );
      return DepositAddress.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
    */

    // --- OPSI B: DUMMY DATA (Agar UI tidak error saat testing) ---
    await Future.delayed(Duration(seconds: 1)); // Simulasi loading
    return DepositAddress(
      address: "0x71C7656EC7ab88b098defB751B7401B5f6d8976F", 
      network: "$channelId Network",
      memo: null,
    );
  }

  Future<void> logout() async {
    await init();
    // Hapus semua cookie
    await _cookieJar?.deleteAll();
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "connection timeout, please check your connection";

      case DioExceptionType.connectionError:
        return "cannot connected to server";

      case DioExceptionType.badResponse:
        final dynamic data = e.response?.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey("message")) {
            return data["message"];
          }
        }

        return "bad request";
      default:
        return "something error";
    }
  }
}
