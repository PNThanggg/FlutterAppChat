import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chopper/chopper.dart';

part 'call_api.chopper.dart';

@ChopperApi(baseUrl: 'call')
abstract class CallApi extends ChopperService {
  @GET(path: "/active", optionalBody: true)
  Future<Response> getActiveCall();

  @GET(path: "/history", optionalBody: true)
  Future<Response> getCallHistory();

  @GET(path: "/agora-access/{roomId}", optionalBody: true)
  Future<Response> getAgoraAccess(
    @Path() String roomId,
  );

  @POST(path: "/create/{roomId}")
  Future<Response> createCall(
    @Path() String roomId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/accept/{meetId}", optionalBody: true)
  Future<Response> acceptCall(
    @Path() String meetId,
    @Body() Map<String, dynamic> body,
  );

  @POST(path: "/reject/{meetId}", optionalBody: true)
  Future<Response> rejectCall(
    @Path() String meetId,
  );

  @POST(path: "/end/v2/{meetId}", optionalBody: true)
  Future<Response> endCallV2(
    @Path() String meetId,
  );

  @DELETE(path: "/history/clear", optionalBody: true)
  Future<Response> clearHistory();

  @DELETE(path: "/history/clear/{id}", optionalBody: true)
  Future<Response> deleteOneHistory(
    @Path() String id,
  );

  static CallApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$CallApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        AuthInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
    );
    return _$CallApi(client);
  }
}
