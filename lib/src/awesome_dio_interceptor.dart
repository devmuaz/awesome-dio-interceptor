import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:colorize/colorize.dart';
import 'package:dio/dio.dart';

/// A simple dio log interceptor (mainly inspired by the built-in dio
/// `LogInterceptor`), which has coloring features and json formatting
/// so you can have a better readable output.
class AwesomeDioInterceptor implements Interceptor {
  /// Creates a colorful dio logging interceptor, which has the following:
  /// `requestStyle`: The request color style, defaults to `YELLOW`
  ///
  /// `responseStyle`: The response color style, defaults to `GREEN`
  ///
  /// `errorStyle`: The error response color style, defaults to `RED`
  ///
  /// `logRequestHeaders`: Whether to log the request headrers or not,
  /// it should minimize the logging output.
  ///
  /// `logResponseHeaders`: Whether to log the response headrers or not,
  /// it should minimize the logging output.
  ///
  /// `logRequestTimeout`: Whether to log the request timeout info or not,
  /// it should minimize the logging output.
  ///
  /// `logger`: if you want to override the default logger which is `log`,
  /// you can set any printer or logger you prefer.. just pass a refrence
  /// of your function to this function parameter and you're good to go.
  ///
  /// **Example**
  ///
  /// ```dart
  /// dio.interceptors.add(
  ///   AwesomeDioInterceptor(
  ///     logRequestTimeout: false,
  ///
  ///     // Optional, defaults to the 'log' function in the 'dart:developer'
  ///     // package
  ///     logger: debugPrint,
  ///   ),
  /// );
  /// ```
  AwesomeDioInterceptor({
    Styles? requestStyle,
    Styles? responseStyle,
    Styles? errorStyle,
    bool logRequestHeaders = true,
    bool logResponseHeaders = true,
    bool logRequestTimeout = true,
    void Function(String log)? logger,
  })  : _jsonEncoder = const JsonEncoder.withIndent('  '),
        _requestStyle = requestStyle ?? _defaultRequestStyle,
        _responseStyle = responseStyle ?? _defaultResponseStyle,
        _errorStyle = errorStyle ?? _defaultErrorStyle,
        _logRequestHeaders = logRequestHeaders,
        _logResponseHeaders = logResponseHeaders,
        _logRequestTimeout = logRequestTimeout,
        _logger = logger ?? log;

  static const Styles _defaultRequestStyle = Styles.YELLOW;
  static const Styles _defaultResponseStyle = Styles.GREEN;
  static const Styles _defaultErrorStyle = Styles.RED;

  late final JsonEncoder _jsonEncoder;
  late final bool _logRequestHeaders;
  late final bool _logResponseHeaders;
  late final bool _logRequestTimeout;
  late final void Function(String log) _logger;

  late final Styles _requestStyle;
  late final Styles _responseStyle;
  late final Styles _errorStyle;

  void _log({required String key, required String value, Styles? style}) {
    final coloredMessage = Colorize('$key$value').apply(
      style ?? Styles.LIGHT_GRAY,
    );
    _logger('$coloredMessage');
  }

  void _logJson({required String key, dynamic value, Styles? style}) {
    final encodedJson = _jsonEncoder.convert(value);
    _log(key: key, value: encodedJson, style: style);
  }

  void _logHeaders({required Map headers, Styles? style}) {
    _log(key: 'Headers:', value: '', style: style);
    headers.forEach((key, value) {
      _log(
        key: '\t$key: ',
        value: (value is List && value.length == 1)
            ? value.first
            : value.toString(),
        style: style,
      );
    });
  }

  void _logNewLine() => _log(key: '', value: '');

  void _logRequest(RequestOptions options, {Styles? style}) {
    _log(key: '[Request] ->', value: '', style: _requestStyle);
    _log(key: 'Uri: ', value: options.uri.toString(), style: _requestStyle);
    _log(key: 'Method: ', value: options.method, style: _requestStyle);
    _log(
      key: 'Response Type: ',
      value: options.responseType.toString(),
      style: style,
    );
    _log(
      key: 'Follow Redirects: ',
      value: options.followRedirects.toString(),
      style: style,
    );
    if (_logRequestTimeout) {
      _log(
        key: 'Connection Timeout: ',
        value: options.connectTimeout.toString(),
        style: style,
      );
      _log(
        key: 'Send Timeout: ',
        value: options.sendTimeout.toString(),
        style: style,
      );
      _log(
        key: 'Receive Timeout: ',
        value: options.receiveTimeout.toString(),
        style: style,
      );
    }
    _log(
      key: 'Receive Data When Status Error: ',
      value: options.receiveDataWhenStatusError.toString(),
      style: style,
    );
    _log(key: 'Extra: ', value: options.extra.toString(), style: style);
    if (_logRequestHeaders) {
      _logHeaders(headers: options.headers, style: style);
    }
    _logJson(key: 'Request Body:\n', value: options.data, style: style);
  }

  void _logResponse(Response response, {Styles? style, bool error = false}) {
    if (!error) {
      _log(key: '[Response] ->', value: '', style: style);
    }
    _log(key: 'Uri: ', value: response.realUri.toString(), style: style);
    _log(
      key: 'Request Method: ',
      value: response.requestOptions.method,
      style: style,
    );
    _log(key: 'Status Code: ', value: '${response.statusCode}', style: style);
    if (_logResponseHeaders) {
      _logHeaders(headers: response.headers.map, style: style);
    }
    _logJson(key: 'Response Body:\n', value: response.data, style: style);
  }

  void _logError(DioError err, {Styles? style}) {
    _log(key: '[DioError] ->', value: '', style: style);
    _log(key: 'DioError [${err.type}]: ', value: err.message, style: style);
  }

  void _delay() async => await Future.delayed(
        const Duration(milliseconds: 200),
      );

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    _logError(err, style: _errorStyle);
    _logResponse(err.response!, error: true, style: _errorStyle);
    _logNewLine();

    _delay();

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logRequest(options, style: _requestStyle);
    _logNewLine();

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response, style: _responseStyle);
    _logNewLine();

    handler.next(response);
  }
}
