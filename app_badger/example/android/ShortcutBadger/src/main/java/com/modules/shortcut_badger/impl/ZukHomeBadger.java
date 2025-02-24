package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.os.Bundle;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;

import java.util.Collections;
import java.util.List;

public class ZukHomeBadger implements Badger {

    private final Uri CONTENT_URI = Uri.parse("content://com.android.badge/badge");

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Bundle extra = new Bundle();
        extra.putInt("app_badge_count", badgeCount);
        context.getContentResolver().call(CONTENT_URI, "setAppBadgeCount", null, extra);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return Collections.singletonList("com.zui.launcher");
    }
}
