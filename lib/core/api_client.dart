import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiClient {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );
  ApiClient() {
    dio.interceptors.add(LogInterceptor(request: true, responseBody: false));
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          String message = '';
          if (error.type == DioExceptionType.connectionTimeout) {
            message = 'Connection Timeout';
          } else if (error.type == DioExceptionType.connectionError) {
            message = 'connection error';
          } else if (error.type == DioExceptionType.badResponse) {
            message = 'bad response';
          } else {
            message = 'working on it';
          }
          handler.next(
            DioException(
              requestOptions: error.requestOptions,
              type: error.type,
              response: error.response,
              message: message,
            ),
          );
        },
      ),
    );
  }
}
// Future<void> fetchApi() async {
//     final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));
//     try {
//       final reponse = await dio.get(
//         '/pokemon',
//         queryParameters: {'limit': 5, 'offset': 0},
//       );
//       print(reponse.data);
//     } on DioException catch (e) {
//       print('URL: ${e.requestOptions.uri}');
//       print('STATUS CODE ${e.response?.statusCode}');
//     }
//   }