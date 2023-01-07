import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    Logger log = Logger();
    log.e('ERROR_TYPE: ${err.type}');
    log.e('PATH: ${err.requestOptions.path}');
    log.e(err.message);
    log.e(err.response?.data);
    if (err.type == DioErrorType.other) {
      if (err.message.contains("SocketException")) {
        err.error = 'Отсутствует подключение к интернету';
        return handler.reject(err);
      }
    }
    if (err.type == DioErrorType.connectTimeout) {
      err.error = 'Отсутствует подключение к интернету';
      return handler.reject(err);
    }
    if (err.response == null) return handler.reject(err);
    Response response = err.response!;
    // 400 - status code
    if (response.statusCode == 400) {
      try {
        if (response.data == "Нет данных") {
          err.error = 'Нет данных';
          return handler.reject(err);
        }
        if (response.data['email'] != null) {
          if (response.data['email'].contains('user_not_found')) {
            err.error = 'Пользователь не найден';
            return handler.reject(err);
          }
          if (response.data['email'].contains('User with this email already exist')) {
            err.error = 'Пользователь с этим адресом электронной почты уже существует';
            return handler.reject(err);
          }
        }
        if (response.data['username'] != null) {
          if (response.data['username'].contains('User with this username(number) already exist')) {
            err.error = 'Пользователь с таким номером уже существует';
            return handler.reject(err);
          }
        }
        if (response.data['old_password'] != null) {
          err.error = 'Введен неверный текущий пароль';
          return handler.reject(err);
        }
      } catch (_) {
        return handler.reject(err);
      }
    }
    // 401 - status code
    if (response.statusCode == 401) {
      err.error = 'У вас нет доступа к этим данным';
    }
    // 404 - status code
    if (response.statusCode == 404) {
      try {
        if (response.data['detail'].contains('Invalid Credentials')) {
          err.error = 'Неправильно введен логин или пароль';
          return handler.reject(err);
        }
        if (response.data['detail'].contains('User not found')) {
          err.error = 'Неправильно введен логин или пароль';
          return handler.reject(err);
        }
        if (response.data['detail'].contains('please, activate account')) {
          err.error = 'activate account';
          return handler.reject(err);
        }
      } catch (e) {
        return handler.reject(err);
      }
      err.error = 'Информация не найдена';
      return handler.reject(err);
    }
    // 5xx - status code
    if (response.statusCode! >= 500) {
      err.error = 'Повторите попытку позже, возникла внутренняя проблема';
      return handler.reject(err);
    }
    return handler.reject(err);
  }
}
