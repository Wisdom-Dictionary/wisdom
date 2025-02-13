
import 'package:dio/dio.dart';

import '../../session/manager/session_manager.dart';

class AuthInterceptor extends Interceptor {
  final SessionManager _sessionManager;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _sessionManager.endLocalSession();
    }
    super.onError(err, handler);
  }

  AuthInterceptor({
    required SessionManager sessionManager,
  }) : _sessionManager = sessionManager;
}
