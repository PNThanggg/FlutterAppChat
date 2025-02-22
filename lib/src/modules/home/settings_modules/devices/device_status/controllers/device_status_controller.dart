import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

import '../states/device_status_state.dart';

class DeviceStatusController extends SLoadingController<DeviceStatusState?> {
  final txtController = TextEditingController();

  DeviceStatusController()
      : super(
          LoadingState(null),
        );

  @override
  void onClose() {
    txtController.dispose();
  }

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<DeviceStatusState?>(
      onLoading: () async {
        setStateLoading();
        update();
      },
      onError: (exception, trace) {
        setStateError();
        update();
      },
      request: () async {
        return null;
      },
      onSuccess: (response) {
        value.data = response;
        update();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }
}
