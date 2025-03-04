import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../../../core/api_service/api_service.dart';
import '../../../../../../core/models/user_device_model.dart';
import '../views/sheet_for_device_status.dart';

class LinkedDevicesController extends SLoadingController<List<UserDeviceModel>> {
  final _profileApi = GetIt.I.get<ProfileApiService>();

  LinkedDevicesController()
      : super(
          LoadingState(
            [],
          ),
        );

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  void getData() async {
    await vSafeApiCall<List<UserDeviceModel>>(
      onLoading: () async {
        setStateLoading();
        update();
      },
      onError: (exception, trace) {
        setStateError();
        update();
      },
      request: () async {
        return _profileApi.getMyDevices();
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  Future<void> linkDevice(BuildContext context) async {}

  Future<void> onDeviceTap(BuildContext context, UserDeviceModel deviceModel) async {
    await showCupertinoModalBottomSheet(
      expand: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SheetForDeviceStatus(
        deviceModel: deviceModel,
      ),
    );
    getData();
  }
}
