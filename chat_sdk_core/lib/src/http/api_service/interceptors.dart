import 'dart:async';
import 'dart:convert';

import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chopper/chopper.dart';

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
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 404) {
    throw VChatHttpNotFound(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 403) {
    throw VChatHttpForbidden(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  } else if (res.statusCode == 450) {
    unAuthStream450Error.add(true);
    throw VChatHttpUnAuth(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
  if (!res.isSuccessful) {
    throw VChatHttpBadRequest(
      vChatException: (res.error! as Map<String, dynamic>)['data'].toString(),
    );
  }
}

Map<String, dynamic> extractDataFromResponse(Response res) {
  return (res.body as Map<String, dynamic>)['data'] as Map<String, dynamic>;
}

class AuthInterceptor implements Interceptor {
  final String? access;

  AuthInterceptor({this.access});

  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = applyHeader(
      chain.request,
      'authorization',
      "Bearer ${access ?? ChatPreferences.getHashedString(
            key: SStorageKeys.vAccessToken.name,
          )}",
    );
    return chain.proceed(request);
  }
}
