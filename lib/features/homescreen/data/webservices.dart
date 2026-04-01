import 'package:dio/dio.dart';

import 'package:newsapp/core/consts/consts.dart';

String yourAPIKey='';

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
          "apiKey": yourAPIKey,
          'category': category,
        },
      );

      return response.data;
    } on DioException catch (e) {
      print('Error: ${e.message}');

      return {};
    }
  }
}




