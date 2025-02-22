import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../../../core/api_service/profile/profile_api_service.dart';
import '../../../../peer_profile/views/peer_profile_view.dart';

class UsersTabController extends SLoadingController<List<SSearchUser>> {
  UsersTabController(this.profileApiService)
      : super(
          SLoadingState(
            [],
          ),
        );

  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  bool isFinishLoadMore = false;
  bool isSearchOpen = false;
  bool _isLoadMoreActive = false;
  final ProfileApiService profileApiService;
  UserFilterDto _filterDto = UserFilterDto.init();

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    _debounce?.cancel();
  }

  @override
  void onInit() {
    getData();
  }

  Future<void> getUsersDataFromApi() async {
    await vSafeApiCall<List<SSearchUser>>(
      request: () async {
        _filterDto = UserFilterDto.init();
        isFinishLoadMore = false;
        return await profileApiService.appUsers(_filterDto);
      },
      onSuccess: (response) {
        data.clear();
        data.addAll(response);
        unawaited(
          VAppPref.setMap("api/users", {
            "data": response
                .map(
                  (e) => e.toMap(),
                )
                .toList(),
          }),
        );
        update();
      },
      ignoreTimeoutAndNoInternet: false,
    );
  }

  void onItemPress(SSearchUser item, BuildContext context) {
    context.toPage(
      PeerProfileView(
        peerId: item.baseUser.id,
      ),
    );
  }

  Future<bool> onLoadMore() async {
    if (_isLoadMoreActive) {
      return false;
    }

    final res = await vSafeApiCall<List<SSearchUser>>(
      onLoading: () {
        _isLoadMoreActive = true;
      },
      request: () async {
        _filterDto.page = _filterDto.page + 1;
        final users = await profileApiService.appUsers(_filterDto);
        return users;
      },
      onSuccess: (response) {
        if (response.isEmpty) {
          isFinishLoadMore = true;
        }
        notifyListeners();
        _isLoadMoreActive = false;
        data.addAll(response);
        setStateSuccess();
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

  Timer? _debounce;

  void closeSearch() {
    isSearchOpen = false;
    searchController.clear();
    isFinishLoadMore = false;
    _filterDto.page = 1;
    notifyListeners();
    getData();
  }

  void openSearch() {
    isSearchOpen = true;
    searchFocusNode.requestFocus();
    notifyListeners();
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 1500), () async {
      await vSafeApiCall<List<SSearchUser>>(
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
          _filterDto.fullName = query;
          isFinishLoadMore = false;
          final users = await profileApiService.appUsers(_filterDto);
          return users;
        },
        onSuccess: (response) {
          setStateSuccess();
          data.clear();
          data.addAll(response);
        },
        ignoreTimeoutAndNoInternet: false,
      );
    });
  }

  Future getData() async {
    try {
      final oldUsers = VAppPref.getMap("api/users");
      if (oldUsers != null) {
        final list = oldUsers['data'] as List;
        value.data = list
            .map(
              (e) => SSearchUser.fromMap(e),
            )
            .toList();
        setStateSuccess();
        update();
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
    await getUsersDataFromApi();
  }
}
