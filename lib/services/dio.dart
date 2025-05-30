import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://backend.preprod.myxplace.com/api',
      headers: {
        'Accept': 'Application/json',
      },
    ),
  );
}
