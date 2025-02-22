import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/api_service/profile/profile_api_service.dart';

class AdminNotificationController extends SLoadingController<List<AdminNotificationsModel>> {
  AdminNotificationController()
      : super(
          LoadingState(
            [],
          ),
        );

  final _apiService = GetIt.I.get<ProfileApiService>();
  bool isFinishLoadMore = false;
  bool _isLoadMoreActive = false;
  final _filterDto = VBaseFilter(
    limit: 30,
    page: 1,
  );

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<AdminNotificationsModel>>(
      onLoading: () async {
        setStateLoading();
      },
      onError: (exception, trace) {
        setStateError();
      },
      request: () async {
        return _apiService.getMyAdminNotifications();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }
    final res = await vSafeApiCall<List<AdminNotificationsModel>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        ++_filterDto.page;
        return _apiService.getMyAdminNotifications(filter: _filterDto);
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
}
