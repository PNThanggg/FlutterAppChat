import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../peer_profile/views/peer_profile_view.dart';

class BroadcastMembersController extends SLoadingController<List<VBroadcastMember>> {
  final txtController = TextEditingController();
  final String roomId;
  final BuildContext context;

  BroadcastMembersController(
    this.roomId,
    this.context,
  ) : super(
          LoadingState(<VBroadcastMember>[]),
        );

  @override
  void onInit() {
    getData();
  }

  final _filterDto = VBaseFilter(
    limit: 30,
    page: 1,
  );
  bool isFinishLoadMore = false;

  Future<void> getData() async {
    await vSafeApiCall<List<VBroadcastMember>>(
      onLoading: () async {
        setStateLoading();
      },
      onError: (exception, trace) {
        setStateError(exception);
      },
      request: () async {
        return VChatController.I.roomApi.getBroadcastMembers(roomId);
      },
      onSuccess: (response) {
        data.clear();
        data.addAll(response);
        setStateSuccess();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  @override
  void onClose() {
    txtController.dispose();
  }

  Future onUserTab(BuildContext context, BaseUser user) async {
    if (user.isMe) {
      return;
    }

    final data = <ModelSheetItem<int>>[];
    data.add(ModelSheetItem(
      title: S.of(context).deleteMember,
      id: 2,
      iconData: const Icon(PhosphorIconsLight.trash),
    ));
    data.add(ModelSheetItem(
      title: S.of(context).profile,
      id: 5,
      iconData: const Icon(PhosphorIconsLight.user),
    ));
    final res = await VAppAlert.showModalSheetWithActions(
      content: data,
      title: "${user.fullName} ${S.of(context).actions}",
      context: context,
    ) as ModelSheetItem<int>?;
    if (res == null) {
      return;
    }
    if (res.id == 1) {
      if (user.isMe) {
        return;
      }
      await VChatController.I.roomApi.openChatWith(
        peerId: user.id,
      );
      return;
    }
    if (res.id == 5) {
      _peerProfile(context, user.id);
      return;
    }
    final yesOkRes = await VAppAlert.showAskYesNoDialog(
      context: context,
      title: S.of(context).areYouSure,
      content: getContent(context, res.id, user.fullName),
    );
    if (yesOkRes != 1) return;
    if (res.id == 2) {
      //to member
      _kickMember(user.id);
    }
  }

  String getContent(BuildContext context, int id, String fullName) {
    return S.of(context).youAreAboutToDeleteThisUserFromYourList;
  }

  void _kickMember(String identifier) async {
    await vSafeApiCall(
      onLoading: () {},
      request: () async {
        await VChatController.I.roomApi.kickBroadcastUser(
          roomId: roomId,
          peerId: identifier,
        );
      },
      onSuccess: (response) {},
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(message: exception, context: context);
      },
    );

    await getData();
  }

  bool _isLoadMoreActive = false;

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final res = await vSafeApiCall<List<VBroadcastMember>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        ++_filterDto.page;

        return VChatController.I.roomApi.getBroadcastMembers(
          roomId,
          filter: _filterDto,
        );
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        value.data.addAll(response);
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
        }
        if (kDebugMode) {
          print(trace);
        }
        _isLoadMoreActive = false;
      },
    );
    if (res == null || res.isEmpty) {
      return false;
    }
    return true;
  }

  void _peerProfile(BuildContext context, String id) {
    context.toPage(PeerProfileView(peerId: id));
  }
}
