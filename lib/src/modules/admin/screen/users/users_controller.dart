import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../admin.dart';

class UsersController extends SLoadingController<PaginateModel<DashUser>> {
  UsersController()
      : super(
          LoadingState(
            PaginateModel.empty(),
          ),
        );

  final adminApi = GetIt.I.get<SAdminApiService>();
  final paginatorController = NumberPaginatorController();
  int currentPage = 1;

  bool isSortAscending = true;
  final currentFilter = {};

  @override
  void onInit() {
    getUsers();
    paginatorController.addListener(_paginatorControllerListener);
  }

  @override
  void onClose() {
    paginatorController.removeListener(_paginatorControllerListener);
    paginatorController.dispose();
  }

  Future<PaginateModel<DashUser>?> getUsers({
    Map<String, String> filter = const {},
  }) async {
    return await vSafeApiCall<PaginateModel<DashUser>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return adminApi.getDashUsers(
          {
            "page": currentPage,
            "sort": isSortAscending ? "-_id" : "_id",
            ...filter,
          },
        );
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
        return response;
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  void _paginatorControllerListener() async {
    final number = paginatorController.currentPage + 1;
    if (number != currentPage) {
      currentPage = number;
      await getUsers();
    }
  }

  void toggleSort() {
    isSortAscending = !isSortAscending;
    getUsers();
  }

  Future<void> onCopyId(BuildContext context, String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    VAppAlert.showSuccessSnackBar(
      context: context,
      message: S.of(context).copy,
    );
  }

  void onUserTap(String id) {
    UsersTabNavigation.navKey.currentContext?.toPage(
      UserProfile(
        id: id,
      ),
    );
  }

  void onSearch(String query) async {
    if (query.isEmpty) {
      await getUsers();
      return;
    }
    await getUsers(filter: {
      "fullName": query,
    });
  }
}
