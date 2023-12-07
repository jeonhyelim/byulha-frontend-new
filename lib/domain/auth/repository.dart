// repository.dart
import 'package:taba/domain/perfume/perfume.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // Repository(this.dio);

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

  Future<PerfumeDetail> getPerfumeDetail(String perfumeId) async {
    final response = await _dio.post(
      'https://byulha.life/api/perfume/$perfumeId',
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == null) {
      throw Exception('No status code received');
    }

    if (response.statusCode != null && response.statusCode == 200) {
      return PerfumeDetail.fromJson(response.data);
    } else {
      throw Exception('Failed to load perfume detail');
    }
  }

//   Future<PerfumeDetail> perfumeDetail(String perfumeId) async {
//   final response = await dio.post(
//     '/perfume/$perfumeId',
//     data: {
//       'perfumeId': perfumeId,
//     },
//   );
//   return PerfumeDetail.fromJson(response.data);
// }
}
