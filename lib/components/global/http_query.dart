import 'package:dio/dio.dart';
import 'package:i_wow/components/global/error_interceptor.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

//
class HttpQuery {
  Logger log = Logger();
  var dio = Dio();
  String backendURL = 'https://flutter-hh-test-task.iwow.com.kz';

  PrettyDioLogger logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 100,
  );

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headerData,
  }) async {
    try {
      dio.interceptors.add(ErrorInterceptor());
      dio.interceptors.add(logger);
      Map<String, dynamic> header = {};
      Response _result = await dio.get(
        backendURL + '/api' + url,
        options: Options(
          sendTimeout: 30000,
          receiveTimeout: 120000,
          headers: header,
        ),
        queryParameters: queryParameters,
      );
      return _result.data;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        print(e.type);
      }
      if (e.type == DioErrorType.receiveTimeout) {
        print(e.type);
      }
    }
  }

  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headerData,
  }) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(logger);
    Map<String, dynamic> header = {
      "Accept": "application/json",
    };

    var _result = await dio.post(
      backendURL + '/api' + url,
      options: Options(
        method: 'POST',
        sendTimeout: 120000,
        receiveTimeout: 120000,
        headers: header,
      ),
      queryParameters: queryParameters,
      data: data,
    );
    return _result.data;
  }

  Future<dynamic> put({
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headerData,
  }) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(logger);
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
    };
    var _result = await dio.put(
      backendURL + '/api' + url,
      options: Options(
        sendTimeout: 30000,
        receiveTimeout: 120000,
        headers: header,
      ),
      queryParameters: queryParameters,
      data: data,
    );
    return _result.data;
  }

  Future<dynamic> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headerData,
  }) async {
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(logger);
    Map<String, dynamic> header = {
      "Content-Type": "application/json",
    };
    var _result = await dio.delete(
      backendURL + '/api' + url,
      options: Options(
        headers: header,
      ),
      queryParameters: queryParameters,
      data: data,
    );
    return _result.data;
  }
}
