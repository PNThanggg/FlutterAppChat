import 'package:chat_sdk_core/chat_sdk_core.dart';

class Block {
  final VNativeApi _vNativeApi;

  VBlockApiService get _api => _vNativeApi.remote.block;

  Block(
    this._vNativeApi,
  );

  Future<bool> blockUser({
    required String peerId,
  }) async {
    return _api.blockUser(peerId: peerId);
  }

  Future<VSingleBlockModel> checkIfThereBan({
    required String peerId,
  }) async {
    return _api.checkIfThereBan(peerId: peerId);
  }

  Future<bool> unBlockUser({
    required String peerId,
  }) async {
    return _api.unBlockUser(peerId: peerId);
  }
}
