import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/src/adapters/io_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'api_interceptor.dart';

/// 网络请求类
///
/// MYHttp http = MYHttp()
///   ..baseUrl = "http://www.baidu.com"
///   ..proxyIp = "192.168.3.1:8888"
///   ..connectTimeout = 5000
///   ..receiveTimeout = 3000
///   ..interceptors.add(ApiInterceptor())
///   .build();
///
///
class MYHttp extends BaseHttp {
  ///baseUrl
  String baseUrl;

  ///设置Flutter 本地代理 ip
  String proxyIp;

  ///链接超时时间
  int connectTimeout;

  ///读取超时时间
  int receiveTimeout;

  void build() {
    if (baseUrl == null) {
      throw new Exception("baseUrl 不能为空");
    }

    options.baseUrl = baseUrl;

    debugPrint("=baseUrl======" + options.baseUrl.toString());

    ///抓包代理配置
    if (proxyIp != null && proxyIp.isNotEmpty) {
      (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.findProxy = (uri) {
          return 'PROXY $proxyIp';
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }

    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    //添加必要拦截器
    interceptors.add(ApiInterceptor(
        connectTimeout: connectTimeout, receiveTimeout: receiveTimeout));

  }
}

/// 拦截器
///
class ApiInterceptor extends InterceptorsWrapper {
  int connectTimeout;
  int receiveTimeout;

  ApiInterceptor({this.connectTimeout, this.receiveTimeout});

  @override
  Future onResponse(Response response) async {
  }

  @override
  Future onRequest(RequestOptions options) {
    if (options.connectTimeout == 0) {
      options.connectTimeout = connectTimeout;
    }
    if (options.receiveTimeout == 0) {
      options.receiveTimeout = receiveTimeout;
    }
    return super.onRequest(options);
  }
}