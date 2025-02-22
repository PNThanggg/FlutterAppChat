import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chopper/chopper.dart';

part 'block_api.chopper.dart';

@ChopperApi(baseUrl: 'user-ban')
abstract class BlockApi extends ChopperService {
  @POST(path: "/{peerId}/ban", optionalBody: true)
  Future<Response> banUser(
    @Path() String peerId,
  );

  @POST(path: "/{peerId}/un-ban", optionalBody: true)
  Future<Response> unBanUser(
    @Path() String peerId,
  );

  @GET(path: "/{peerId}/ban", optionalBody: true)
  Future<Response> checkBan(
    @Path() String peerId,
  );

  static BlockApi create({
    Uri? baseUrl,
    String? accessToken,
  }) {
    final client = ChopperClient(
      baseUrl: VAppConstants.baseUri,
      services: [
        _$BlockApi(),
      ],
      converter: const JsonConverter(),
      interceptors: [
        AuthInterceptor(),
      ],
      errorConverter: ErrorInterceptor(),
    );
    return _$BlockApi(client);
  }
}
