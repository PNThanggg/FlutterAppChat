package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;
import com.modules.shortcut_badger.util.BroadcastHelper;

import java.util.List;

public class DefaultBadger implements Badger {
    private static final String INTENT_ACTION = IntentConstants.DEFAULT_INTENT_ACTION;
    private static final String INTENT_EXTRA_BADGE_COUNT = "badge_count";
    private static final String INTENT_EXTRA_PACKAGENAME = "badge_count_package_name";
    private static final String INTENT_EXTRA_ACTIVITY_NAME = "badge_count_class_name";

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Intent intent = new Intent(INTENT_ACTION);
        intent.putExtra(INTENT_EXTRA_BADGE_COUNT, badgeCount);
        intent.putExtra(INTENT_EXTRA_PACKAGENAME, componentName.getPackageName());
        intent.putExtra(INTENT_EXTRA_ACTIVITY_NAME, componentName.getClassName());

        BroadcastHelper.sendDefaultIntentExplicitly(context, intent);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of("fr.neamar.kiss", "com.quaap.launchtime", "com.quaap.launchtime_official");
    }

    boolean isSupported(Context context) {
        Intent intent = new Intent(INTENT_ACTION);
        return !BroadcastHelper.resolveBroadcast(context, intent).isEmpty() || (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !BroadcastHelper.resolveBroadcast(context, new Intent(IntentConstants.DEFAULT_OREO_INTENT_ACTION)).isEmpty());
    }
}
