// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'violation_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$ViolationApi extends ViolationApi {
  _$ViolationApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = ViolationApi;

  @override
  Future<Response<dynamic>> getAllViolation() {
    final Uri $url = Uri.parse('violation-text/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addViolation(Map<String, String> body) {
    final Uri $url = Uri.parse('violation-text/create');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteViolation(String id) {
    final Uri $url = Uri.parse('violation-text/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
