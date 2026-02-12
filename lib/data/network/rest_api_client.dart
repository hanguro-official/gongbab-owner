import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../domain/utils/result.dart';
import '../models/common_model.dart';

enum RestMethod { get, post, put, patch, delete }

class RestApiClient {
  RestApiClient({required this.dio});

  final Dio dio;

  Future<Result<T>> request<T>({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _requestByMethod(
        method: method,
        path: path,
        queryParameters: queryParameters,
        data: data,
      );
      Logger().d('uri:${response.realUri}\nstatusCode: ${response.statusCode}\ndata: ${response.data}');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Result.success(fromJson(response.data));
      } else {
        final data = CommonModel.fromJson(response.data);
        return Result.failure(data.success, data.error);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        try {
          final data = CommonModel.fromJson(e.response!.data);
          return Result.failure(data.success, data.error);
        } catch (_) {
          return Result.error(e.message ?? 'Network error occurred');
        }
      }
      return Result.error(e.message ?? 'Network error occurred');
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<Uint8List>> requestBytes({ // New method for binary data
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _requestByMethod(
        method: method,
        path: path,
        queryParameters: queryParameters,
        responseType: ResponseType.bytes, // Always bytes for this method
      );
      Logger().d(
          'uri:${response.realUri}\nstatusCode: ${response.statusCode}\ndata: [Binary Data]'); // Avoid logging binary data
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Result.success(response.data as Uint8List);
      } else {
        // Assuming error response is still JSON for CommonModel
        final data = CommonModel.fromJson(response.data);
        return Result.failure(data.success, data.error);
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        try {
          final data = CommonModel.fromJson(e.response!.data);
          return Result.failure(data.success, data.error);
        } catch (_) {
          return Result.error(e.message ?? 'Network error occurred');
        }
      }
      return Result.error(e.message ?? 'Network error occurred');
    } catch (e) {
      return Result.error(e.toString());
    }
  }


  Future<Response> _requestByMethod({
    required RestMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    ResponseType? responseType, // Added responseType parameter
  }) {
    switch (method) {
      case RestMethod.get:
        return dio.get(path, queryParameters: queryParameters, options: Options(responseType: responseType));
      case RestMethod.post:
        return dio.post(path, data: data, queryParameters: queryParameters);
      case RestMethod.put:
        return dio.put(path, data: data, queryParameters: queryParameters);
      case RestMethod.patch:
        return dio.patch(path, data: data, queryParameters: queryParameters);
      case RestMethod.delete:
        return dio.delete(path, data: data, queryParameters: queryParameters);
    }
  }
}