// GENERATED CODE - DO NOT MODIFY BY HAND

part of 's_admin_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SAdminApi extends SAdminApi {
  _$SAdminApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SAdminApi;

  @override
  Future<Response<dynamic>> dashboard() {
    final Uri $url = Uri.parse('admin-panel/dashboard');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> config() {
    final Uri $url = Uri.parse('admin-panel/config');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateConfig(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('admin-panel/config');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> login() {
    final Uri $url = Uri.parse('admin-panel/login');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getDashUsers(Map<String, dynamic> body) {
    final Uri $url = Uri.parse('admin-panel/users');
    final Map<String, dynamic> $params = body;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getNotifications() {
    final Uri $url = Uri.parse('admin-panel/notifications');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> createNotifications(
    MultipartFile? file,
    List<PartValue<dynamic>> body,
  ) {
    final Uri $url = Uri.parse('admin-panel/notifications');
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<MultipartFile?>(
        'file',
        file,
      )
    ];
    $parts.addAll(body);
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> updateUserData(
    String id,
    Map<String, dynamic> body,
  ) {
    final Uri $url = Uri.parse('admin-panel/user/info/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getUserInfo(String id) {
    final Uri $url = Uri.parse('admin-panel/user/info/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getAllStaff() {
    final Uri $url = Uri.parse('admin-panel/users/all-staff');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> toggleStaff(String id) {
    final Uri $url = Uri.parse('admin-panel/users/toggle-staff/${id}');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
