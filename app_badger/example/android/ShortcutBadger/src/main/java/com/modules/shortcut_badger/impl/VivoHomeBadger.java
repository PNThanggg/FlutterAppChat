package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;

import java.util.List;

public class VivoHomeBadger implements Badger {

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Intent intent = new Intent("launcher.action.CHANGE_APPLICATION_NOTIFICATION_NUM");
        intent.putExtra("packageName", context.getPackageName());
        intent.putExtra("className", componentName.getClassName());
        intent.putExtra("notificationNum", badgeCount);
        context.sendBroadcast(intent);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of("com.vivo.launcher");
    }
}
