import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_config/app_config_controller.dart';

class ChatMediaState {
  final List<VBaseMessage> media;
  final List<VBaseMessage> files;
  final List<VBaseMessage> links;

  ChatMediaState({
    this.media = const <VBaseMessage>[],
    this.files = const <VBaseMessage>[],
    this.links = const <VBaseMessage>[],
  });
}

class ChatMediaController extends SLoadingController<ChatMediaState> {
  final String roomId;

  ChatMediaController(this.roomId)
      : super(
          LoadingState(
            ChatMediaState(),
          ),
        );

  final appConfigController = GetIt.I.get<VAppConfigController>();

  @override
  void onInit() {
    getData();
  }

  @override
  void onClose() {}

  void getData() {
    vSafeApiCall<ChatMediaState>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        final media = await VChatController.I.nativeApi.remote.message.getRoomMessages(
          roomId: roomId,
          dto: VRoomMessagesDto(filter: VMessagesFilter.media, limit: 60),
        );
        final files = await VChatController.I.nativeApi.remote.message.getRoomMessages(
          roomId: roomId,
          dto: VRoomMessagesDto(filter: VMessagesFilter.file, limit: 60),
        );
        final links = await VChatController.I.nativeApi.remote.message.getRoomMessages(
          roomId: roomId,
          dto: VRoomMessagesDto(filter: VMessagesFilter.links, limit: 60),
        );
        return ChatMediaState(
          media: media,
          files: files,
          links: links,
        );
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (exception, trace) {
        setStateError();
      },
    );
  }
}
