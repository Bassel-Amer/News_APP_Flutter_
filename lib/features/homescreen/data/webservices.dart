import 'package:dio/dio.dart';

import 'package:newsapp/core/consts/consts.dart';

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
          "apiKey": "9bd498111e3d402fb2103e2dc16d9e92",
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




// Singleton Pattern //

// class Webservices {
//   // 1. The Private Static Instance
//   // This holds the ONE true copy of your Webservices in memory.
//   static final Webservices _instance = Webservices._internal();

//   late Dio dio;

//   // 2. The Factory Constructor
//   // Whenever ANY file in your app calls Webservices(), it doesn't create a new one.
//   // It just hands them the '_instance' we created above.
//   factory Webservices() {
//     return _instance;
//   }

//   // 3. The Private Internal Constructor
//   // The underscore (_) means "private". This block of code only ever runs exactly ONCE.
//   Webservices._internal() {
//     BaseOptions options = BaseOptions(
//       baseUrl: 'https://newsapi.org/v2/',
//       receiveDataWhenStatusError: true,
//       connectTimeout: const Duration(seconds: 20),
//       receiveTimeout: const Duration(seconds: 20),
//     );

//     dio = Dio(options);

//     dio.interceptors.add(LogInterceptor(
//       responseBody: true,
//       error: true,
//       requestHeader: false,
//     ));
//   }