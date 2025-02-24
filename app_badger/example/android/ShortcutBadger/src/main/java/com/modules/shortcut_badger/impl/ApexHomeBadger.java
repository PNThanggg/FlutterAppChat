package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;
import com.modules.shortcut_badger.util.BroadcastHelper;

import java.util.List;

public class ApexHomeBadger implements Badger {

    private static final String INTENT_UPDATE_COUNTER = "com.anddoes.launcher.COUNTER_CHANGED";
    private static final String PACKAGENAME = "package";
    private static final String COUNT = "count";
    private static final String CLASS = "class";

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Intent intent = new Intent(INTENT_UPDATE_COUNTER);
        intent.putExtra(PACKAGENAME, componentName.getPackageName());
        intent.putExtra(COUNT, badgeCount);
        intent.putExtra(CLASS, componentName.getClassName());

        BroadcastHelper.sendIntentExplicitly(context, intent);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of("com.anddoes.launcher");
    }
}
