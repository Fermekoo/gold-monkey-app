import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:gold_monkey/data/models/login_model.dart';
import 'package:gold_monkey/data/models/register_model.dart';
import 'package:gold_monkey/data/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class AuthService {
  final Dio _dio = Dio();
  PersistCookieJar? _cookieJar;

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String get baseUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:8080";
    }
    return "http://127.0.0.1:8080";
  }

  Future<void> init() async {
    if (_cookieJar != null) return;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    _cookieJar = PersistCookieJar(
      storage: FileStorage("$appDocPath/.cookies/"),
    );

    _dio.interceptors.add(CookieManager(_cookieJar!));

    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<bool> register(RegisterRequest request) async{
    try {
      final response = await _dio.post(
        '$baseUrl/v1/register',
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20)
        )
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch(e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception("register failed: ${e.toString()}");
    }
  }

  Future<bool> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '$baseUrl/v1/login',
        data: request.toJson(),
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20)
        )
      );

      return response.statusCode == 200;
    } on DioException catch(e) {
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

  Future<void> logout() async {
     await init();
     // Hapus semua cookie
     await _cookieJar?.deleteAll();
  }

  String _handleError(DioException e) {
    switch(e.type) {
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