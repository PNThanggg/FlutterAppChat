import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../admin.dart';
import '../state/violation_state.dart';

class ViolationController extends SLoadingController<ViolationState> {
  ViolationController()
      : super(
          SLoadingState<ViolationState>(
            ViolationState.empty(),
          ),
        );

  final ViolationApiService _violationApiService = GetIt.I.get<ViolationApiService>();

  final TextEditingController textEditingController = TextEditingController();

  @override
  void onClose() {
    textEditingController.clear();
    textEditingController.dispose();
  }

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<ViolationModel>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await _violationApiService.getAllViolation();
      },
      onSuccess: (response) {
        value.data = value.data.copyWith(list: response);
        setStateSuccess();
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  Future<void> deleteViolationById(int index) async {
    ViolationModel item = value.data.listViolation[index];

    await vSafeApiCall<bool>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await _violationApiService.deleteViolation(item.id!);
      },
      onSuccess: (response) {
        if (response) {
          value.data.listViolation.removeAt(index);
          notifyListeners();
        }

        setStateSuccess();
      },
      onError: (exception, trace) {
        showToast(exception);

        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  Future<void> addViolation() async {
    if (textEditingController.text.isEmpty) {
      showToast("Violation empty!!!");
      return;
    }

    await vSafeApiCall<ViolationModel>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await _violationApiService.addViolation(
          {
            "text": textEditingController.text,
          },
        );
      },
      onSuccess: (response) {
        if (response.text != null) {
          value.data.listViolation.add(response);
          notifyListeners();
        }

        setStateSuccess();
      },
      onError: (exception, trace) {
        showToast(exception);

        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }
}
