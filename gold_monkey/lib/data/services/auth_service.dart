import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:gold_monkey/core/utils/nav_key.dart';
import 'package:gold_monkey/data/models/deposit_model.dart';
import 'package:gold_monkey/data/models/login_model.dart';
import 'package:gold_monkey/data/models/register_model.dart';
import 'package:gold_monkey/data/models/user_model.dart';
import 'package:gold_monkey/data/models/wallet_model.dart';
import 'package:gold_monkey/views/login_screen.dart';
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

    _cookieJar = PersistCookieJar(storage: FileStorage("$appDocPath/.cookies/"));
    
    _dio.interceptors.clear();

    _dio.interceptors.add(CookieManager(_cookieJar!));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, ErrorInterceptorHandler handler) async {
         
          if (e.response?.statusCode == 401) {
            print("🚨 SESSION EXPIRED (401) DETECTED! LOGGING OUT...");
            
           
            await _cookieJar?.deleteAll();

            
            navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false, 
            );
          }
      
          return handler.next(e); 
        },
      ),
    );

    // 3. Log Interceptor (Untuk Debugging)
    _dio.interceptors.add(
      LogInterceptor(request: true, responseBody: true, error: true),
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
          final List<Cookie> cookies = rawCookies.map((str) {
            return Cookie.fromSetCookieValue(str);
          }).toList();

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
      final response = await _dio.get('$baseUrl/v1/dashboard');
      return DashboardData.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<DepositChannel>> getDepositChannels() async {
    await init();
    try {
      final response = await _dio.get('$baseUrl/v1/deposit/channels');
      final List<dynamic> list = response.data['data'] ?? [];
      
      return list.map((e) => DepositChannel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DepositAddress> getDepositAddress(String assetCode) async {
    await init();
    
    try {
      final response = await _dio.post(
        '$baseUrl/v1/deposit/address',
        data: {
          'asset': assetCode, 
        },
      
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      return DepositAddress.fromJson(response.data);
    }on DioException catch (e) {
      throw _handleError(e); 
    }
  }

Future<bool> checkSessionValidity() async {
    await init();
    
    
    final uri = Uri.parse(baseUrl);
    final cookies = await _cookieJar?.loadForRequest(uri);
    if (cookies == null || cookies.isEmpty) return false;

    try {
      final response = await _dio.get('$baseUrl/v1/profile');
    
      if (response.data is Map && response.data['data'] == null) {
    
        print("⚠️ Response 200 tapi data kosong. Anggap Invalid.");
        return false;
      }

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await init();
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
