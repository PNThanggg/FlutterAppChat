package com.modules.shortcut_badger.impl;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;
import com.modules.shortcut_badger.util.BroadcastHelper;

import java.util.Collections;
import java.util.List;

public class OPPOHomeBader implements Badger {

    private static final String PROVIDER_CONTENT_URI = "content://com.android.badge/badge";
    private static final String INTENT_ACTION = "com.oppo.unsettledevent";
    private static final String INTENT_EXTRA_PACKAGENAME = "pakeageName";
    private static final String INTENT_EXTRA_BADGE_COUNT = "number";
    private static final String INTENT_EXTRA_BADGE_UPGRADENUMBER = "upgradeNumber";
    private static final String INTENT_EXTRA_BADGEUPGRADE_COUNT = "app_badge_count";
    private int mCurrentTotalCount = -1;

    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        if (mCurrentTotalCount == badgeCount) {
            return;
        }
        mCurrentTotalCount = badgeCount;
        executeBadgeByContentProvider(context, badgeCount);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return Collections.singletonList("com.oppo.launcher");
    }

    private void executeBadgeByBroadcast(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        if (badgeCount == 0) {
            badgeCount = -1;
        }
        Intent intent = new Intent(INTENT_ACTION);
        intent.putExtra(INTENT_EXTRA_PACKAGENAME, componentName.getPackageName());
        intent.putExtra(INTENT_EXTRA_BADGE_COUNT, badgeCount);
        intent.putExtra(INTENT_EXTRA_BADGE_UPGRADENUMBER, badgeCount);

        BroadcastHelper.sendIntentExplicitly(context, intent);
    }

    /**
     * Send request to OPPO badge content provider to set badge in OPPO home launcher.
     *
     * @param context    the context to use
     * @param badgeCount the badge count
     */
    private void executeBadgeByContentProvider(Context context, int badgeCount) throws ShortcutBadgeException {
        try {
            Bundle extras = new Bundle();
            extras.putInt(INTENT_EXTRA_BADGEUPGRADE_COUNT, badgeCount);
            context.getContentResolver().call(Uri.parse(PROVIDER_CONTENT_URI), "setAppBadgeCount", null, extras);
        } catch (Throwable ignored) {
            throw new ShortcutBadgeException("Unable to execute Badge By Content Provider");
        }
    }
}