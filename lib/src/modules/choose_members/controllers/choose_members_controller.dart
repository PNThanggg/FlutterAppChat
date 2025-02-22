import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

import '../../../core/api_service/profile/profile_api_service.dart';

class ChooseMembersController extends SLoadingController<List<SSelectableUser>> {
  final txtController = TextEditingController();
  final ProfileApiService profileApiService;
  final Function(List<SBaseUser> selectedUsers) onDone;
  Timer? _debounce;
  final selectedUsers = <SSelectableUser>[];
  bool isFinishLoadMore = false;
  final String? groupId;
  final String? broadcastId;

  ChooseMembersController(
    this.profileApiService,
    this.onDone,
    this.groupId,
    this.broadcastId,
  ) : super(SLoadingState(<SSelectableUser>[]));

  UserFilterDto _filterDto = UserFilterDto.init();

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<SSelectableUser>>(
      onLoading: () async {
        setStateLoading();
        update();
      },
      onError: (exception, trace) {
        setStateError();
        update();
      },
      request: () async {
        _filterDto = UserFilterDto.init();
        isFinishLoadMore = false;
        if (groupId != null) {
          final users = await VChatController.I.nativeApi.remote.room.getAvailableGroupMembersToAdded(
            roomId: groupId!,
            filter: _filterDto,
          );

          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        } else if (broadcastId != null) {
          final users = await VChatController.I.nativeApi.remote.room.getAvailableBroadcastMembersToAdded(
            roomId: broadcastId!,
            filter: _filterDto,
          );
          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        } else {
          final users = await profileApiService.appUsers(_filterDto);
          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        }
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          setStateEmpty();
          return;
        }
        setStateSuccess();
        data.addAll(response);
        maintainTheUsers();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  void onSearchChanged(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1500), () {
      vSafeApiCall<List<SSelectableUser>>(
        onLoading: () {
          setStateLoading();
          update();
        },
        onError: (exception, trace) {
          setStateError();
          update();
        },
        request: () async {
          _filterDto = UserFilterDto.init();
          _filterDto.fullName = query;
          isFinishLoadMore = false;
          var users = <SSearchUser>[];

          if (groupId != null) {
            users = await VChatController.I.nativeApi.remote.room.getAvailableGroupMembersToAdded(
              roomId: groupId!,
              filter: _filterDto,
            );
          } else if (broadcastId != null) {
            users = await VChatController.I.nativeApi.remote.room.getAvailableBroadcastMembersToAdded(
              roomId: broadcastId!,
              filter: _filterDto,
            );
          } else {
            users = await profileApiService.appUsers(_filterDto);
          }
          return users.map((e) => SSelectableUser(searchUser: e)).toList();
        },
        onSuccess: (response) {
          data.clear();
          if (response.isEmpty) {
            setStateEmpty();
            return;
          }
          data.addAll(response);
          maintainTheUsers();
          setStateSuccess();
        },
        ignoreTimeoutAndNoInternet: false,
      );
    });
  }

  void maintainTheUsers() {
    //i need to let the selectedUsers each user inside the selectedUsers must find the same user inside the data and set isSelected it to true founded
    Map<String, SSelectableUser> dataMap = {for (var v in data) v.searchUser.baseUser.id: v};
    for (var selectedUser in selectedUsers) {
      var foundedUser = dataMap[selectedUser.searchUser.baseUser.id];
      if (foundedUser != null) {
        foundedUser.isSelected = true;
      }
    }

    update();
  }

  @override
  void onClose() {
    txtController.dispose();
    _debounce?.cancel();
  }

  void selectUser(SSelectableUser user) {
    if (selectedUsers.length >= VChatController.I.vChatConfig.maxForward) {
      return;
    }

    final founded = data.firstWhereOrNull((e) => e.searchUser.baseUser.id == user.searchUser.baseUser.id);
    founded?.isSelected = true;
    selectedUsers.add(user);
    update();
  }

  void unSelectUser(SSelectableUser user) {
    final founded = data.firstWhereOrNull((e) => e.searchUser.baseUser.id == user.searchUser.baseUser.id);
    founded?.isSelected = false;
    selectedUsers.removeWhere((element) => element.searchUser.baseUser.id == user.searchUser.baseUser.id);
    update();
  }

  bool get isThereSelection => selectedUsers.isNotEmpty;

  void onNext(BuildContext context) {
    if (!isThereSelection) {
      VAppAlert.showErrorSnackBar(
        message: S.of(context).chooseAtLestOneMember,
        context: context,
      );
      return;
    }
    onDone(selectedUsers.toList().map((e) => e.searchUser.baseUser).toList());
  }

  bool _isLoadMoreActive = false;

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final res = await vSafeApiCall<List<SSelectableUser>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        _filterDto.page = _filterDto.page + 1;
        final users = await profileApiService.appUsers(_filterDto);
        return users.map((e) => SSelectableUser(searchUser: e)).toList();
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        value.data.addAll(response);
        maintainTheUsers();
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
}
