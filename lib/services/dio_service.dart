import 'package:dio/dio.dart';
import 'package:get_ex_currency/const.dart';

class DioService {
  final Dio _dio = Dio();

  DioService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options =
        BaseOptions(baseUrl: "https://api.cryptorank.io/v1/", queryParameters: {
      "api_key": API_KEY_CRYPTO_IO,
    });
  }

  Future<dynamic> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
 //Use http if you need a simple HTTP client with minimal setup and don't require advanced features.
// Use dio if you need more control over HTTP requests, such as interceptors, file uploads, request cancellation, or advanced error handling.
// Interceptors: Allows you to intercept requests and responses to modify them or handle errors globally.