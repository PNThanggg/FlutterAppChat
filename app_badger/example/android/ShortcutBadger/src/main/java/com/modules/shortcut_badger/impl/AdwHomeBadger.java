package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;
import com.modules.shortcut_badger.util.BroadcastHelper;

import java.util.List;

public class AdwHomeBadger implements Badger {

    public static final String INTENT_UPDATE_COUNTER = "org.adw.launcher.counter.SEND";
    public static final String PACKAGENAME = "PNAME";
    public static final String CLASSNAME = "CNAME";
    public static final String COUNT = "COUNT";

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Intent intent = new Intent(INTENT_UPDATE_COUNTER);
        intent.putExtra(PACKAGENAME, componentName.getPackageName());
        intent.putExtra(CLASSNAME, componentName.getClassName());
        intent.putExtra(COUNT, badgeCount);

        BroadcastHelper.sendIntentExplicitly(context, intent);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of("org.adw.launcher", "org.adwfreak.launcher");
    }
}
