import 'dart:async';

import 'package:chat_config/chat_preferences.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:http/http.dart' as http;

/// This class handles the API requests both local and remote and also has a Streams class.
class VNativeApi {
  final local = VLocalNativeApi();
  final remote = VRemoteNativeApi(
    VChannelApiService.init(),
    VMessageApiService.init(),
    VProfileApiService.init(),
    VCallApiService.init(),
    VBlockApiService.init(),
  );
  final streams = VStreams();

  VNativeApi._();

  bool _isControllerInit = false;

  static final _instance = VNativeApi._();

  /// Returns the single instance of [VNativeApi].
  static VNativeApi get I {
    return _instance;
  }

  /// Initializes the [VNativeApi] instance.
  static Future<VNativeApi> init() async {
    assert(
      !_instance._isControllerInit,
      'This controller is already initialized',
    );
    _instance._isControllerInit = true;
    await _instance.local.init();
    await _instance.local.dbCompleter.future;
    return _instance;
  }
}

/// This class manages local database operations such as messages, rooms, and cache.
class VLocalNativeApi {
  late final NativeLocalMessage message;
  late final NativeLocalRoom room;
  late final NativeLocalApiCache apiCache;

  Completer<void> get dbCompleter => DBProvider.instance.dbCompleter;

  Future<VLocalNativeApi> init() async {
    final database = await DBProvider.instance.database;
    message = NativeLocalMessage(database);
    await message.prepareMessages();
    room = NativeLocalRoom(database, message);
    apiCache = NativeLocalApiCache(database);
    return this;
  }

  /// Resets the database.
  Future reCreate() async {
    await message.reCreateMessageTable();
    await room.reCreateRoomTable();
  }
}

/// This class manages remote API operations such as socket events, HTTP requests,
/// authentication, messages, profile, calls and block operations.
class VRemoteNativeApi {
  final socketIo = NativeRemoteSocketIo();
  final VChannelApiService _room;
  final VMessageApiService _nativeRemoteMessage;
  final VCallApiService _nativeRemoteCallApiService;
  final VBlockApiService _nativeRemoteBlockApiService;
  final VProfileApiService _nativeProfileApiService;

  VRemoteNativeApi(
    this._room,
    this._nativeRemoteMessage,
    this._nativeProfileApiService,
    this._nativeRemoteCallApiService,
    this._nativeRemoteBlockApiService,
  );

  VChannelApiService get room => _room;

  /// Performs a native HTTP request.
  Future<http.Response> nativeHttp(
    Uri uri, {
    required VChatHttpMethods method,
    required Map<String, dynamic>? body,
    Map<String, String> headers = const {},
  }) async {
    headers['authorization'] = "Bearer ${ChatPreferences.getHashedString(
      key: SStorageKeys.vAccessToken.name,
    )}";
    headers["clint-version"] = VAppConstants.clintVersion;
    switch (method) {
      case VChatHttpMethods.get:
        return http.get(uri, headers: headers);
      case VChatHttpMethods.post:
        return http.post(uri, body: body, headers: headers);
      case VChatHttpMethods.patch:
        return http.patch(uri, body: body, headers: headers);
      case VChatHttpMethods.delete:
        return http.delete(uri, body: body, headers: headers);
      case VChatHttpMethods.put:
        return http.put(uri, body: body, headers: headers);
    }
  }

  VMessageApiService get message => _nativeRemoteMessage;

  VProfileApiService get profile => _nativeProfileApiService;

  VCallApiService get calls => _nativeRemoteCallApiService;

  VBlockApiService get block => _nativeRemoteBlockApiService;
}
