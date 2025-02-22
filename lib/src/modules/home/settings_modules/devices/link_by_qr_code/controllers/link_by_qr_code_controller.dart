import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

import '../states/link_by_qr_code_state.dart';

class LinkByQrCodeController extends SLoadingController<LinkByQrCodeState?> {
  final txtController = TextEditingController();

  LinkByQrCodeController() : super(LoadingState(null));

  @override
  void onClose() {
    txtController.dispose();
  }

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<LinkByQrCodeState?>(
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
