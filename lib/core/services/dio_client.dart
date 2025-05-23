import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wisdom/config/constants/urls.dart';
import 'package:wisdom/core/services/custom_client.dart';

import '../session/manager/session_manager.dart';
import 'interceptors/interceptors.dart';

extension ResponseExt on Response {
  bool get isSuccessful => statusCode == 200 || statusCode == 201;
}

class DioClient {
  final SessionManager _sessionManager;
  final NetWorkChecker _netWorkChecker;
  final String _debugUrl = Urls.baseUrl;
  final String _prodUrl = Urls.baseUrl;
  // final String _prodUrl = "https://api.wisdomedu.usoftdevs.uz";
  final bool _isDebug = false;
  late Dio _dio;

  DioClient(this._sessionManager, this._netWorkChecker) {
    _dio = Dio();
    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        request: true,
        error: true,
        requestBody: true,
        responseBody: true,
      ),
    );
    _dio.interceptors.add(AuthInterceptor(sessionManager: _sessionManager));
  }

  Future<BaseOptions> _getOptions() async {
    return BaseOptions(
      baseUrl: _isDebug ? _debugUrl : _prodUrl,
      responseType: ResponseType.plain,
      connectTimeout: Duration(milliseconds: _sessionManager.timeout),
      receiveTimeout: Duration(milliseconds: _sessionManager.timeout),
      headers: {
        _sessionManager.authorization: _sessionManager.accessToken,
        "Accept": "application/json"
      },
      validateStatus: (code) => _sessionManager.validate(code ?? 0),
    );
  }

  CancelToken cancelToken() {
    return CancelToken();
  }

  Future<Response<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    if (!(await _netWorkChecker.isNetworkAvailable())) {
      throw const SocketException('message');
    }
    _dio.options = await _getOptions();
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    if (!(await _netWorkChecker.isNetworkAvailable())) {
      throw const SocketException('');
    }
    _dio.options = await _getOptions();
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!(await _netWorkChecker.isNetworkAvailable())) {
      throw const SocketException('');
    }
    _dio.options = await _getOptions();
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (!(await _netWorkChecker.isNetworkAvailable())) {
      throw const SocketException('');
    }
    _dio.options = await _getOptions();
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}
