import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../../../v_chat_message_page.dart';
import '../../providers/message_provider.dart';

class MessageState {
  final List<VBaseMessage> listMessage;
  final List<VBaseMessage> listStarMessage;

  MessageState({
    required this.listMessage,
    required this.listStarMessage,
  });

  factory MessageState.empty() {
    return MessageState(
      listMessage: <VBaseMessage>[],
      listStarMessage: <VBaseMessage>[],
    );
  }

  MessageState copyWith({
    List<VBaseMessage>? listMessage,
    List<VBaseMessage>? listStarMessage,
  }) {
    return MessageState(
      listMessage: listMessage ?? this.listMessage,
      listStarMessage: listStarMessage ?? this.listStarMessage,
    );
  }

  @override
  String toString() {
    return 'MessageStatusState{listMessage: $listMessage, listStarMessage: $listStarMessage}';
  }
}

class MessageStateController extends ValueNotifier<MessageState> with VSocketStatusStream {
  final VRoom vRoom;
  final MessageProvider messageProvider;
  final AutoScrollController scrollController;
  LoadMoreStatus _loadingStatus = LoadMoreStatus.loaded;

  MessageStateController({
    required this.vRoom,
    required this.messageProvider,
    required this.scrollController,
  }) : super(
          MessageState.empty(),
        ) {
    initSocketStatusStream(
      VChatController.I.nativeApi.streams.socketStatusStream,
    );
    getMessagesFromLocal();
    getStarMessage();
    unawaited(getMessagesFromRemote(_initFilterDto));
    scrollController.addListener(_loadMoreListener);
  }

  BuildContext get context => VChatController.I.navigationContext;

  void _initLoadMore() {
    _loadingStatus = LoadMoreStatus.loaded;
    _filterDto.lastId = null;
  }

  List<VBaseMessage> get stateMessages => value.listMessage;

  List<VBaseMessage> get starMessages => value.listStarMessage;

  final messageStateStream = StreamController<VBaseMessage>.broadcast();

  bool get isMessagesEmpty => stateMessages.isEmpty;

  String get roomId => vRoom.id;

  String get lastMessageId => stateMessages.last.id;
  final _initFilterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );
  final _filterDto = VRoomMessagesDto(
    limit: 30,
    lastId: null,
  );

  void insertAllMessages(List<VBaseMessage> messages) {
    value = value.copyWith(
      listMessage: sort(messages),
    );
  }

  Future<void> getStarMessage() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return VChatController.I.nativeApi.remote.message.getStarRoomMessages(roomId: roomId);
      },
      onSuccess: (response) {
        value = value.copyWith(listStarMessage: response);
        notifyListeners();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  void updateApiMessages(List<VBaseMessage> apiMessages) {
    if (apiMessages.isEmpty) return;
    final List<VBaseMessage> newList = <VBaseMessage>[];
    final stateMessages = value.listMessage;

    // Combine apiMessages and sending/error messages from stateMessages
    newList.addAll(apiMessages);
    newList.addAll(
      stateMessages.where(
        (e) => e.emitStatus.isSendingOrError,
      ),
    );

    // Replace updated messages in newList
    for (final localDbMessage in stateMessages) {
      if (localDbMessage.contentTr != null || localDbMessage.isDownloading) {
        final index = newList.indexWhere(
          (element) => element.id == localDbMessage.id,
        );
        if (index != -1) {
          newList[index] = localDbMessage;
        }
      }
    }

    // Sort and update value only if context is still mounted
    if (context.mounted) {
      value = value.copyWith(
        listMessage: sort(newList),
      );
    }
  }

  List<VBaseMessage> sort(List<VBaseMessage> messages) {
    messages.sort((a, b) {
      return b.id.compareTo(a.id);
    });
    return messages;
  }

  void insertMessage(VBaseMessage messageModel) {
    if (!stateMessages.contains(messageModel)) {
      value.listMessage.insert(0, messageModel);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print("-------------you are try to insert message which already exist!-----------");
      }
    }
  }

  void updateMessage(VBaseMessage messageModel) {
    final msgIndex = stateMessages.indexOf(messageModel);
    if (msgIndex != -1) {
      //full update
      value.listMessage[msgIndex] = messageModel;
      messageStateStream.sink.add(messageModel);
    } else {
      if (kDebugMode) {
        print("----------------you are try to update message which Not exist!--------------");
      }
    }
  }

  void close() {
    messageStateStream.close();
    dispose();
    closeSocketStatusStream();
  }

  int _indexByLocalId(String localId) => value.listMessage.indexWhere(
        (e) => e.localId == localId,
      );

  void deleteMessage(String localId) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].isDeleted = true;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void updateMessageStatus(String localId, VMessageEmitStatus emitState) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].emitStatus = emitState;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void updateMessageStar(String localId, VUpdateMessageStarEvent event) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].isStared = event.isStar;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void updateMessageOneSeen(String localId, VUpdateMessageOneSeenEvent event) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].isOneSeenByMe = true;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void updateDownloadProgress(String localId, double progress) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].progress = progress;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void updateMessageAllDeletedAt(String localId, String? allDeletedAt) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].allDeletedAt = allDeletedAt;
      messageStateStream.add(value.listMessage[index]);
    }
  }

  void seenAll(VSocketOnRoomSeenModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].seenAt ??= model.date;
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  void deliverAll(VSocketOnDeliverMessagesModel model) {
    for (int i = 0; i < stateMessages.length; i++) {
      stateMessages[i].deliveredAt ??= model.date;
    }
    notifyListeners();
  }

  @override
  void onSocketConnected() {
    getMessagesFromRemote(_initFilterDto);
    messageProvider.setSeen(vRoom.id);
  }

  Future<void> getMessagesFromRemote(VRoomMessagesDto dto) async {
    await VChatController.I.nativeApi.remote.socketIo.socketCompleter.future;
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getApiMessages(
          roomId: vRoom.id,
          dto: dto,
        );
      },
      onSuccess: (response) {
        updateApiMessages(response);
        VDownloaderService.instance.checkIfCanAutoDownloadFor(response);
      },
    );
  }

  Future<void> getMessagesFromLocal() async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: _initFilterDto,
        );
      },
      onSuccess: (response) {
        insertAllMessages(response);
        VDownloaderService.instance.checkIfCanAutoDownloadFor(response);
      },
    );
  }

  void emitSeenFor(String roomId) {
    messageProvider.setSeen(roomId);
  }

  bool get requireLoadMoreMessages =>
      _loadingStatus != LoadMoreStatus.loading && _loadingStatus != LoadMoreStatus.completed;

  void _loadMoreListener() async {
    final maxScrollExtent = scrollController.position.maxScrollExtent / 2;
    if (scrollController.offset > maxScrollExtent && requireLoadMoreMessages) {
      await loadMoreMessages();
    }
  }

  Future<List<VBaseMessage>?> loadMoreMessages() async {
    _loadingStatus = LoadMoreStatus.loading;
    _filterDto.lastId = value.listMessage.last.id;
    final localLoadedMessages = await messageProvider.getLocalMessages(
      roomId: vRoom.id,
      filter: _filterDto,
    );
    if (localLoadedMessages.isEmpty) {
      ///if no more data ask server for it
      return await vSafeApiCall<List<VBaseMessage>>(
        request: () async {
          return messageProvider.getApiMessages(
            roomId: vRoom.id,
            dto: _filterDto,
          );
        },
        onSuccess: (response) {
          if (response.isEmpty) {
            _loadingStatus = LoadMoreStatus.completed;
            return null;
          }
          _loadingStatus = LoadMoreStatus.loaded;
          value.listMessage.addAll(response);
          VDownloaderService.instance.checkIfCanAutoDownloadFor(response);
          notifyListeners();
          return response;
        },
      );
    }
    _loadingStatus = LoadMoreStatus.loaded;
    value.listMessage.addAll(localLoadedMessages);
    notifyListeners();
    return localLoadedMessages;
  }

  Future<void> loadUntil(VBaseMessage message) async {
    await vSafeApiCall<List<VBaseMessage>>(
      request: () async {
        return messageProvider.getLocalMessages(
          roomId: vRoom.id,
          filter: VRoomMessagesDto(
            between: VMessageBetweenFilter(
              lastId: value.listMessage.last.id,
              targetId: message.id,
            ),
          ),
        );
      },
      onSuccess: (response) {
        value.listMessage.insertAll(0, response);
        notifyListeners();
      },
    );
  }

  void messageSearch(String text) async {
    final searchMessages = await messageProvider.search(vRoom.id, text);
    value = value.copyWith(
      listMessage: searchMessages,
    );
    notifyListeners();
  }

  void resetMessages() {
    _initLoadMore();
    getMessagesFromLocal();
  }

  void updateIsDownloading(String localId, bool isDownload) {
    final index = _indexByLocalId(localId);
    if (index != -1) {
      value.listMessage[index].isDownloading = isDownload;
      messageStateStream.add(value.listMessage[index]);
    }
  }
}
