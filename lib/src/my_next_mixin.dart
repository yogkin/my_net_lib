import 'package:flutter/foundation.dart';

import 'api_interceptor.dart';
import 'i_my_loading.dart';
import 'my_http.dart';

///网络请求 混合类[MYBaseNetMixin]
///
///
abstract class MYBaseNetMixin implements IMYLoading {
  MYHttp httpClient();

  ///通用post请求
  ///
  Future doPost(String api,
      {params, dynamic data, withLoading = true, Options options}) async {
    if (withLoading) {
      showLoading();
    }
    Response response;
    try {
      options = options ?? Options();
      options.contentType = 'application/json';
      response =
      await httpClient().post(api, data: params ?? data, options: options);
    } on DioError catch (e) {
      debugPrint('DioError: ${e.hashCode} $e');
      return resultError(e.message);
    } finally {
      if (withLoading) {
        hideLoading();
      }
    }
    return response.data;
  }

  ///通用get请求
  ///
  Future doGet<T extends MYNetBeanMixin>(String api,
      {params, withLoading = true}) async {
    if (withLoading) {
      showLoading();
    }
    Response response;
    try {
      response = await httpClient().get(api, queryParameters: params);
    } on DioError catch (e) {
      return resultError(e.message);
    } finally {
      if (withLoading) {
        hideLoading();
      }
    }

    return response.data;
  }

  void resultError(String errorMsg) {
    showToast(errorMsg);
    throw NotSuccessException('出错了 $errorMsg');
  }
}

///解析的实体类，需要继承[MYNetBeanMixin]
///
///
abstract class MYNetBeanMixin {
  Map<String, dynamic> toJson();

  fromJson(dynamic json);
}

