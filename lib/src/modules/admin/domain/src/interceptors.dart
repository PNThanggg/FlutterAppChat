import 'dart:async';
import 'dart:convert';

import 'package:chat_config/chat_preferences.dart';
import 'package:chopper/chopper.dart';

import 'exceptions.dart';

class ErrorInterceptor implements ErrorConverter {
  @override
  FutureOr<Response> convertError<BodyType, InnerType>(Response response) {
    final errorMap = jsonDecode(response.body.toString()) as Map<String, dynamic>;

    return response.copyWith(
      bodyError: errorMap,
      body: errorMap,
    );
  }
}

void throwIfNotSuccess(Response res) {
  if (res.isSuccessful) return;

  if (res.statusCode == 400) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 404) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 403) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw SuperHttpBadRequest(
      exception: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

Map<String, dynamic> extractDataFromResponse(Response res) {
  return (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>;
}

class SAdminHeaderKeySetterInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'admin-key',
      "${ChatPreferences.getHashedString(key: SStorageKeys.adminAccessPassword.name)}",
    );

    return chain.proceed(request);
  }
}

class AuthInterceptor implements Interceptor {
  final String? access;

  AuthInterceptor({
    this.access,
  });

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'authorization',
      "Bearer ${access ?? ChatPreferences.getHashedString(key: SStorageKeys.vAccessToken.name)}",
    );
    return chain.proceed(request);
  }
}

class ViolationInterceptor implements Interceptor {
  final String? access;

  ViolationInterceptor({
    this.access,
  });

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'authorization',
      "Bearer ${access ?? ChatPreferences.getHashedString(key: SStorageKeys.vAccessToken.name)}",
    );
    return chain.proceed(request);
  }
}
