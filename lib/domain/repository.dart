// repository.dart
import 'package:taba/domain/perfume/perfume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/login/login.dart';

final repositoryProvider = Provider<Repository>((ref) => Repository());
/*
class Repository {
  final Dio _dio = Dio();

  Future<PerfumeList> getPerfumeList() async {
    final response = await _dio.get(
      'https://byulha.life/api/perfume?page=0&size=20',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    await Future.delayed(Duration(seconds: 2));
    return PerfumeList.fromJson(response.data);
  }
}

 */


class Repository {
  final Dio _dio = Dio();

  Future<String> getSignupToken() async {
    final response = await _dio.get('/user/signup-token');
    return response.data['signupToken'];
  }

  Future<bool> sendSMS({required String phoneNumber, required String signupToken}) async {
    final response = await _dio.post(
      '/sms/$signupToken',
      data: {
        'phoneNumber': phoneNumber,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifySMS({required String code, required String signupToken}) async {
    final response = await _dio.post(
      '/sms/verify/$signupToken',
      data: {
        'code': code,
      },
    );
    return response.statusCode == 200;
  }

  Future<Login> login(String nickname, String password) async {
    final response = await _dio.post(
      '/user/login',
      data: {
        'nickname': nickname,
        'password': password,
      },
    );
    return Login.fromJson(response.data);
  }

  Future<bool> signUp({
    required String signupToken,
    required String name,
    required String nickname,
    required String age,
    required String gender,
    required String phone,
    required String password,
  }) async {
    final response = await _dio.post(
      '/user/$signupToken',
      data: {
        'name': name,
        'nickname': nickname,
        'age' : age,
        'gender' : gender,
        'phone' : phone,
        'password': password,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifyNickname({required String nickname}) async {
    final response = await _dio.post(
      '/user/signup/verify/$nickname',
    );
    return response.statusCode == 200;
  }

  Future<PerfumeList> getPerfumeList(int page, int size) async {
    final response = await _dio.get(
      'https://byulha.life/api/perfume?page=$page&size=$size&sort=rating,desc',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );
    if (response.statusCode == 200) {
      return PerfumeList.fromJson(response.data);
    } else {
      throw Exception('Failed to load perfumes');
    }
  }
}
