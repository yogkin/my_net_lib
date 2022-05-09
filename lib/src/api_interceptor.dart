import 'dart:convert';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
export 'package:dio/dio.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

/// http 基类
///
abstract class BaseHttp extends DioForNative {

}


/// 子类需要重写
///
abstract class BaseRespModel {
  int code = 200;
  String message = '';
  dynamic data;

  bool get success;


  BaseRespModel.create();

  BaseRespModel(
      {this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseEntity{code: $code, message: $message, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
///
class NotSuccessException implements Exception {
  String message = "";
  int code = 0;

  NotSuccessException(this.message);

  NotSuccessException.fromRespData(BaseRespModel respData) {
    message = respData.message;
    code = respData.code;
  }

  @override
  String toString() {
    return '$message';
  }
}