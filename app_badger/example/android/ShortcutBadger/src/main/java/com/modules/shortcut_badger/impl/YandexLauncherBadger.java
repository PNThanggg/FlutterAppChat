package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;

import java.util.List;

public class YandexLauncherBadger implements Badger {

    public static final String PACKAGE_NAME = "com.yandex.launcher";

    private static final String AUTHORITY = "com.yandex.launcher.badges_external";
    private static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY);
    private static final String METHOD_TO_CALL = "setBadgeNumber";

    private static final String COLUMN_CLASS = "class";
    private static final String COLUMN_PACKAGE = "package";
    private static final String COLUMN_BADGES_COUNT = "badges_count";

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Bundle extras = new Bundle();
        extras.putString(COLUMN_CLASS, componentName.getClassName());
        extras.putString(COLUMN_PACKAGE, componentName.getPackageName());
        extras.putString(COLUMN_BADGES_COUNT, String.valueOf(badgeCount));
        context.getContentResolver().call(CONTENT_URI, METHOD_TO_CALL, null, extras);
    }

    public static boolean isVersionSupported(Context context) {
        try {
            context.getContentResolver().call(CONTENT_URI, "", null, null);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of(PACKAGE_NAME);
    }
}
