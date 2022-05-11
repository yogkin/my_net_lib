import 'package:flutter/foundation.dart';

import 'api_interceptor.dart';
import 'http_code.dart';
import 'i_my_loading.dart';
import 'my_http.dart';
import 'my_http_exception.dart';

///网络请求 混合类[MYBaseNetMixin]
///
abstract class MYBaseNetMixin implements IMYLoading {
  MYHttp httpClient();

  ///通用post请求
  ///
  ///[api]请求地址
  ///[params]请求参数
  ///[isShowLoading]是否显示加载框
  ///[options]请求配置
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
      debugPrint('DioError: ${e.toString()} $e');
      return resultHttpError(HttpCode.httpRequestFailure, e.message);
    } catch (e, _) {
      debugPrint('DioError: ${e.hashCode} $e');
      return resultHttpError(HttpCode.httpRequestFailure, e.message);
    } finally {
      if (withLoading) {
        hideLoading();
      }
    }
    return response.data;
  }

  ///通用get请求
  ///
  ///[api] 请求地址
  ///[params] 请求参数
  ///[withLoading] 是否显示加载中
  ///
  Future doGet(String api, {params, withLoading = true}) async {
    if (withLoading) {
      showLoading();
    }
    Response response;
    try {
      response = await httpClient().get(api, queryParameters: params);
    } on DioError catch (e) {
      return resultHttpError(HttpCode.httpRequestFailure, e.message);
    } catch (e, _) {
      debugPrint('DioError: ${e.hashCode} $e');
      return resultHttpError(HttpCode.httpRequestFailure, e.message);
    } finally {
      if (withLoading) {
        hideLoading();
      }
    }

    return response.data;
  }

  ///处理网络异常，比如连接失败、超时等
  ///
  Future resultHttpError(int code, String errorMsg) async {
    showToast(errorMsg);
    throw MYHttpException(code, errorMsg);
  }
}

///解析的实体类，需要继承[MYNetBeanMixin]
///
///
abstract class MYNetBeanMixin {
  Map<String, dynamic> toJson();

  fromJson(dynamic json);
}
