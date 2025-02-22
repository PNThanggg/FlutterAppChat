import 'dart:async';

import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/api_service/api_service.dart';
import '../../mobile/settings_tab/widgets/settings_list_item_tile.dart';

class MyPrivacyPage extends StatefulWidget {
  const MyPrivacyPage({super.key});

  @override
  State<MyPrivacyPage> createState() => _MyPrivacyPageState();
}

class _MyPrivacyPageState extends State<MyPrivacyPage> {
  UserPrivacy _userPrivacy = AppAuth.myProfile.userPrivacy;
  final _profileApi = GetIt.instance.get<ProfileApiService>();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          CupertinoSliverNavigationBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            border: Border.all(color: Colors.transparent),
            largeTitle: Text(
              S.of(context).myPrivacy,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 25,
              ),
            ),
          )
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 10),
                child: S.of(context).configureYourAccountPrivacy.text.color(Colors.grey),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: VPlatforms.isMobile ? 15 : 0),
                decoration: BoxDecoration(
                  color: context.theme.cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: CupertinoListSection(
                  backgroundColor: Colors.transparent,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  dividerMargin: 0,
                  separatorColor: Colors.transparent,
                  topMargin: 10,
                  additionalDividerMargin: 0,
                  margin: EdgeInsets.zero,
                  hasLeading: false,
                  children: [
                    SettingsListItemTile(
                      color: Colors.amber,
                      title: S.of(context).youInPublicSearch,
                      subtitle: S.of(context).yourProfileAppearsInPublicSearchAndAddingForGroups.text,
                      icon: Icons.search,
                      trailing: CupertinoSwitch(
                        value: _userPrivacy.publicSearch,
                        onChanged: _onUpdatePublicSearch,
                      ),
                    ),
                    SettingsListItemTile(
                      color: Colors.green,
                      title: S.of(context).yourLastSeen,
                      subtitle: S.of(context).yourLastSeenInChats.text,
                      icon: Icons.last_page_rounded,
                      trailing: CupertinoSwitch(
                        value: _userPrivacy.lastSeen,
                        onChanged: _onUpdateLastSeen,
                      ),
                    ),
                    SettingsListItemTile(
                      color: Colors.blue,
                      title: S.of(context).startNewChatWithYou,
                      subtitle: S.of(context).soon.text,
                      // onTap: _onUpdateStartChat,
                      icon: CupertinoIcons.chat_bubble_text,
                    ),
                    SettingsListItemTile(
                      color: Colors.black26,
                      title: S.of(context).yourStory,
                      subtitle: S.of(context).soon.text,
                      //  onTap: _onUpdateShowStory,
                      icon: Icons.history_toggle_off_rounded,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onUpdatePublicSearch(bool value) async {
    _userPrivacy = _userPrivacy.copyWith(publicSearch: value);
    await _updateLocalProfile();
  }

  Future<void> _onUpdateLastSeen(bool value) async {
    _userPrivacy = _userPrivacy.copyWith(lastSeen: value);
    await _updateLocalProfile();
  }

  Future<void> _onUpdateStartChat() async {
    final res = await VAppAlert.showModalSheetWithActions<UserPrivacyType>(
      context: context,
      content: [
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).forRequest,
          id: UserPrivacyType.forReq,
        ),
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).public,
          id: UserPrivacyType.public,
        ),
      ],
    ) as ModelSheetItem<UserPrivacyType>?;
    if (res == null) return;
    _userPrivacy = _userPrivacy.copyWith(startChat: res.id);
    await _updateLocalProfile();
  }

  Future<void> _onUpdateShowStory() async {
    final res = await VAppAlert.showModalSheetWithActions<UserPrivacyType>(
      context: context,
      content: [
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).forRequest,
          id: UserPrivacyType.forReq,
        ),
        ModelSheetItem<UserPrivacyType>(
          title: S.of(context).public,
          id: UserPrivacyType.public,
        ),
      ],
    ) as ModelSheetItem<UserPrivacyType>?;
    if (res == null) return;
    _userPrivacy = _userPrivacy.copyWith(showStory: res.id);

    await _updateLocalProfile();
  }

  Future<void> _updateLocalProfile() async {
    final newProfile = AppAuth.myProfile.copyWith(
      userPrivacy: _userPrivacy,
    );
    await ChatPreferences.setMap(SStorageKeys.myProfile.name, newProfile.toMap());
    AppAuth.setProfileNull();
    setState(() {});
    _updateInApi();
  }

  String _getTrans(UserPrivacyType type) {
    switch (type) {
      case UserPrivacyType.forReq:
        return S.of(context).forRequest;
      case UserPrivacyType.public:
        return S.of(context).public;
      case UserPrivacyType.none:
        return S.of(context).none;
    }
  }

  Future _updateInApi() async {
    vSafeApiCall(
      request: () async {
        return _profileApi.updatePrivacy(_userPrivacy);
      },
      onSuccess: (response) {},
      onError: (exception, trace) {
        VAppAlert.showErrorSnackBar(message: exception, context: context);
        if (kDebugMode) {
          print(exception);
        }
      },
    );
  }
}
