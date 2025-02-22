import 'package:chat_config/chat_constants.dart';

import '../../../admin.dart';
import 'violation_api.dart';

class ViolationApiService {
  ViolationApiService._();

  static ViolationApi? _violationApi;

  static ViolationApiService init({
    Uri? baseUrl,
    String? accessToken,
    Map<String, String>? headers,
  }) {
    _violationApi ??= ViolationApi.create(
      accessToken: accessToken,
      headers: headers,
      baseUrl: baseUrl ?? ChatConstants.sApiBaseUrl,
    );
    return ViolationApiService._();
  }

  Future<List<ViolationModel>> getAllViolation() async {
    final res = await _violationApi!.getAllViolation();
    throwIfNotSuccess(res);

    return (res.body["data"] as List)
        .map(
          (e) => ViolationModel.fromJson(e),
        )
        .toList();
  }

  Future<bool> deleteViolation(String id) async {
    final res = await _violationApi!.deleteViolation(id);
    throwIfNotSuccess(res);

    Map result = extractDataFromResponse(res);

    return result['deletedCount'] as int != 0;
  }

  Future<ViolationModel> addViolation(Map<String, String> body) async {
    final res = await _violationApi!.addViolation(body);
    throwIfNotSuccess(res);
    return ViolationModel.fromJson((res.body["data"] as List).first);
  }
}
