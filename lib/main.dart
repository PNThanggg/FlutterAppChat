import 'dart:async';

import 'package:chat_config/chat_constants.dart';
import 'package:chat_config/chat_preferences.dart';
import 'package:chat_core/chat_core.dart';
import 'package:chat_message_page/chat_message_page.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_room_page/chat_room_page.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:window_manager/window_manager.dart';

import 'firebase_options.dart';
import 'src/core/widgets/main_builder.dart';
import 'src/di/admin_di.dart';
import 'src/di/app_di.dart';
import 'src/modules/splash/views/splash_view.dart';
import 'v_chat_v2/v_chat_config.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (VPlatforms.isDeskTop) {
    await _setDesktopWindow();
  }

  if (VPlatforms.isWeb) {
    //remove # from web url
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    setPathUrlStrategy();
  }

  AppDi.inject();
  AdminDI.inject();

  VPlatformFileUtils.baseMediaUrl = ChatConstants.baseMediaUrl;
  if (VPlatforms.isMobile || VPlatforms.isMacOs || VPlatforms.isWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await ChatPreferences.init();
  await initVChat(navigatorKey);

  // initCalls();
  // Set dark theme as default only on first run
  final savedTheme = ChatPreferences.getStringOrNullKey(SStorageKeys.appTheme.name);
  if (savedTheme == null) {
    await ChatPreferences.setStringKey(
      SStorageKeys.appTheme.name,
      ThemeMode.dark.name,
    );
  }

  runApp(
    VUtilsWrapper(
      builder: (_, theme) {
        return Theme(
          data: _getIosBrightness(theme) == Brightness.dark
              ? ThemeData.dark().copyWith(
                  extensions: [
                    MessageTheme.dark().copyWith(
                      senderBubbleColor: const Color(0xff005046),
                      receiverBubbleColor: const Color(0xff363638),
                      senderTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                      ),
                      receiverTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.5,
                      ),
                    ),
                    VRoomTheme.dark().copyWith(
                        //see options here
                        ),
                  ],
                )
              : ThemeData.light().copyWith(
                  extensions: [
                    MessageTheme.light().copyWith(
                      senderBubbleColor: const Color(0xffE2FFD4),
                      receiverBubbleColor: const Color(0xffFFFFFF),
                      senderTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.5,
                      ),
                      receiverTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.5,
                      ),
                    ),
                    VRoomTheme.light().copyWith(),
                  ],
                ),
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: ChatConstants.appName,
            // locale: local,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) => Material(
              child: MainBuilder(
                themeMode: theme,
                child: child,
              ),
            ),
            themeMode: _getIosBrightness(theme) == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashView(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: _getIosBrightness(theme),
              primaryColor: const Color(0xff003554),
              fontFamily: "SvnGilroy",
              scaffoldBackgroundColor: Colors.grey.shade100,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 16.5,
                  color: Colors.black,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16.5,
                  color: Colors.black,
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.blueAccent,
              ),
              navigationBarTheme: NavigationBarThemeData(
                iconTheme: WidgetStateProperty.all<IconThemeData>(
                  const IconThemeData(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              dividerColor: Colors.grey.shade300,
              cardColor: Colors.white,
              hintColor: Colors.grey.shade500,
              highlightColor: const Color(0xfff4f4f6),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xff003554),
              fontFamily: "SvnGilroy",
              scaffoldBackgroundColor: const Color(0xff000814),
              iconTheme: const IconThemeData(
                color: Colors.blueAccent,
              ),
              navigationBarTheme: NavigationBarThemeData(
                iconTheme: WidgetStateProperty.all<IconThemeData>(
                  const IconThemeData(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(
                  fontSize: 16.5,
                  color: Colors.white,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16.5,
                  color: Colors.white,
                ),
              ),
              dividerColor: Colors.grey.shade300,
              cardColor: const Color(0xff001129),
              hintColor: Colors.grey.shade200,
              highlightColor: const Color(0xff003566),
            ),
          ),
        );
      },
    ),
  );
}

Brightness _getIosBrightness(ThemeMode themeMode) {
  if (themeMode == ThemeMode.dark) {
    return Brightness.dark;
  }

  if (themeMode == ThemeMode.light) {
    return Brightness.light;
  }

  unawaited(
    ChatPreferences.setStringKey(
      SStorageKeys.appTheme.name,
      ThemeMode.light.name,
    ),
  );

  return Brightness.light;
}

Future<void> _setDesktopWindow() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    // minimumSize: const Size(600, 800),
    // size: const Size(1500, 800),
    // backgroundColor: Colors.black,
    // skipTaskbar: true,
    // title: SConstants.appName,
    // titleBarStyle: VPlatforms.isWindows ? TitleBarStyle.normal : TitleBarStyle.hidden,
    // fullScreen: false,
    // center: true,
    // windowButtonVisibility: true,
    minimumSize: const Size(600, 800),
    size: const Size(1500, 800),
    center: true,
    title: ChatConstants.appName,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: VPlatforms.isWindows ? TitleBarStyle.normal : TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  // await autoUpdater.setFeedURL(SConstants.feedUrl);
  // await autoUpdater.setScheduledCheckInterval(3600 + 12);
}
