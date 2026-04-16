import 'package:dio/dio.dart';

import 'package:newsapp/core/consts/consts.dart';

String apiKey = "9bd498111e3d402fb2103e2dc16d9e92";

class Webservices {
  late Dio dio;

  Webservices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseurl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 25),
      receiveTimeout: const Duration(seconds: 3),
    );

    dio = Dio(options);

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: false,
        error: true,
      ),
    );
  }

  Future<Map<String, dynamic>> getinfo({
    required String category,
    String country = 'us',
  }) async {
    try {
      Response response = await dio.get(
        'top-headlines',
        queryParameters: {
          "country": country,
          "apiKey": apiKey,
          'category': category,
        },
      );

      return response.data;
    } on DioException catch (e) {
      print('Error: ${e.message}');

      return {};
    }
  }

  Future<Map<String, dynamic>> searchNews({required String keywords}) async {
    try {
      Response response = await dio.get(
        'everything',
        queryParameters: {"apiKey": apiKey, 'q': keywords},
      );

      return response.data;
    } on DioException catch (e) {
      print('Error: ${e.message}');

      return {};
    }
  }
}
