import 'dart:convert';

import 'package:chat_config/chat_constants.dart';
import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../mobile/settings_tab/widgets/settings_list_item_tile.dart';

class TestNotificationScreen extends StatefulWidget {
  const TestNotificationScreen({super.key});

  @override
  State<TestNotificationScreen> createState() => _TestNotificationScreenState();
}

class _TestNotificationScreenState extends State<TestNotificationScreen> {
  List<dynamic> _resultSuccess = [];
  List<dynamic> _resultFailure = [];

  bool _isLoading = false;

  Future<void> _testNotification() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    String url = "${ChatConstants.sApiBaseUrl}/notification/test";

    final Dio dio = Dio();
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );

    await vSafeApiCall<Response>(
      onLoading: () {
        setState(() {
          _isLoading = true;
        });
      },
      request: () async {
        return dio.post(
          url,
          data: jsonEncode(
            {
              "title": "Kiem tra",
              "body": "OK",
            },
          ),
          options: Options(
            headers: {
              "Authorization": "Bearer ${ChatPreferences.getHashedString(key: SStorageKeys.vAccessToken.name)}",
            },
          ),
        );
      },
      onSuccess: (response) {
        showToast(
          message: response.data['data']['body'],
          context,
        );

        _resultSuccess = response.data['data']['result']['successResponses'] as List<dynamic>;
        _resultFailure = response.data['data']['result']['failureResponses'] as List<dynamic>;

        setState(() {
          _isLoading = false;
        });
        return response;
      },
      onError: (exception, trace) {
        setState(() {
          _isLoading = false;
        });

        if (kDebugMode) {
          print(exception);
          print(trace);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              "Test notification",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          )
        ],
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsListItemTile(
                color: Colors.blueAccent,
                title: "Send notification",
                onTap: () => _testNotification(),
                icon: Icons.notifications_none_rounded,
                textColor: context.theme.textTheme.bodyMedium?.color,
                trailing: const SizedBox.shrink(),
              ),
              const SizedBox(
                height: 12,
              ),
              _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: context.theme.dividerColor,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Success device",
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      _resultSuccess
                          .map((item) => item.entries.map((e) => "${e.key}: ${e.value}").join(", "))
                          .join("\n"),
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: context.theme.dividerColor,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Failure device",
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      _resultFailure
                          .map((item) => item.entries.map((e) => "${e.key}: ${e.value}").join(", "))
                          .join("\n"),
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
