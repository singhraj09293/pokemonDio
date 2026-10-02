import 'package:dio/dio.dart';

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