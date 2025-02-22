import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

import '../states/privacy_policy_state.dart';

class PrivacyPolicyController extends SLoadingController<PrivacyPolicyState?> {
  final txtController = TextEditingController();

  PrivacyPolicyController()
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
    await vSafeApiCall<PrivacyPolicyState?>(
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
