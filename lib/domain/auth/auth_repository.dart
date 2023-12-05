import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taba/domain/auth/login/login.dart';
import 'package:taba/utils/dio_provider.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(dioProvider)));

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<String> getSignupToken() async {
    final response = await dio.get('/user/signup-token');
    return response.data['signupToken'];
  }

  Future<bool> sendSMS({required String phoneNumber, required String signupToken}) async {
    final response = await dio.post(
      '/sms/$signupToken',
      data: {
        'phoneNumber': phoneNumber,
      },
    );
    return response.statusCode == 200;
  }

  Future<bool> verifySMS({required String code, required String signupToken}) async {
    final response = await dio.post(
      '/sms/verify/$signupToken',
      data: {
        'code': code,
      },
    );
    return response.statusCode == 200;
  }

  Future<Login> login(String nickname, String password) async {
    final response = await dio.post(
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
    final response = await dio.post(
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
    final response = await dio.post(
      '/user/signup/verify/$nickname',
    );
    return response.statusCode == 200;
  }
}
