package com.modules.shortcut_badger.impl;

import android.content.AsyncQueryHandler;
import android.content.ComponentName;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ProviderInfo;
import android.net.Uri;

import com.modules.shortcut_badger.Badger;
import com.modules.shortcut_badger.ShortcutBadgeException;
import com.modules.shortcut_badger.util.BroadcastHelper;

import java.util.List;

public class AsusHomeBadger implements Badger {
    private static final String INTENT_ACTION = IntentConstants.DEFAULT_INTENT_ACTION;
    private static final String INTENT_EXTRA_BADGE_COUNT = "badge_count";
    private static final String INTENT_EXTRA_PACKAGENAME = "badge_count_package_name";
    private static final String INTENT_EXTRA_ACTIVITY_NAME = "badge_count_class_name";

    private static final String PROVIDER_CONTENT_URI = "content://com.android.badge/";
    private static final String PROVIDER_COLUMNS_BADGE_COUNT = "badge_count";
    private static final String PROVIDER_COLUMNS_PACKAGE_NAME = "package_name";
    private static final String PROVIDER_COLUMNS_ACTIVITY_NAME = "activity_name";
    private static final String ASUS_LAUNCHER_PROVIDER_NAME = "com.android.badge";
    private final Uri BADGE_CONTENT_URI = Uri.parse(PROVIDER_CONTENT_URI);

    private AsyncQueryHandler mQueryHandler;

    // It seems that Asus handle Sony like badges better than old implementation...
    private static final String SONY_INTENT_ACTION = "com.sonyericsson.home.action.UPDATE_BADGE";
    private static final String SONY_INTENT_EXTRA_PACKAGE_NAME = "com.sonyericsson.home.intent.extra.badge.PACKAGE_NAME";
    private static final String SONY_INTENT_EXTRA_ACTIVITY_NAME = "com.sonyericsson.home.intent.extra.badge.ACTIVITY_NAME";
    private static final String SONY_INTENT_EXTRA_MESSAGE = "com.sonyericsson.home.intent.extra.badge.MESSAGE";
    private static final String SONY_INTENT_EXTRA_SHOW_MESSAGE = "com.sonyericsson.home.intent.extra.badge.SHOW_MESSAGE";


    @Override
    public void executeBadge(Context context, ComponentName componentName, int badgeCount) throws ShortcutBadgeException {
        Intent intent = new Intent(INTENT_ACTION);
        intent.putExtra(INTENT_EXTRA_BADGE_COUNT, badgeCount);
        intent.putExtra(INTENT_EXTRA_PACKAGENAME, componentName.getPackageName());
        intent.putExtra(INTENT_EXTRA_ACTIVITY_NAME, componentName.getClassName());
        intent.putExtra("badge_vip_count", 0);

        BroadcastHelper.sendDefaultIntentExplicitly(context, intent);
    }

    private void executeBadgeByBroadcast(Context context, ComponentName componentName, int badgeCount) {
        Intent intent = new Intent(SONY_INTENT_ACTION);
        intent.putExtra(SONY_INTENT_EXTRA_PACKAGE_NAME, componentName.getPackageName());
        intent.putExtra(SONY_INTENT_EXTRA_ACTIVITY_NAME, componentName.getClassName());
        intent.putExtra(SONY_INTENT_EXTRA_MESSAGE, String.valueOf(badgeCount));
        intent.putExtra(SONY_INTENT_EXTRA_SHOW_MESSAGE, badgeCount > 0);
        // FIXME: BroadcastHelper fail to resolve broadcast and then don't broadcast intent while it works.
//         BroadcastHelper.sendDefaultIntentExplicitly(context, intent);
        context.sendBroadcast(intent);
    }

    @Override
    public List<String> getSupportLaunchers() {
        return List.of("com.asus.launcher");
    }

    /**
     * Asynchronously inserts the badge counter.
     *
     * @param contentValues Content values containing the badge count, package and activity names
     */
    private void insertBadgeAsync(final ContentValues contentValues) {
        mQueryHandler.startInsert(0, null, BADGE_CONTENT_URI, contentValues);
    }

    /**
     * Synchronously inserts the badge counter.
     *
     * @param context       Caller context
     * @param contentValues Content values containing the badge count, package and activity names
     */
    private void insertBadgeSync(final Context context, final ContentValues contentValues) {
        context.getApplicationContext().getContentResolver().insert(BADGE_CONTENT_URI, contentValues);
    }

    /**
     * Creates a ContentValues object to be used in the badge counter update. The package and
     * activity names must correspond to an activity that holds an intent filter with action
     * "android.intent.action.MAIN" and category android.intent.category.LAUNCHER" in the manifest.
     * Also, it is not allowed to publish badges on behalf of another client, so the package and
     * activity names must belong to the process from which the insert is made.
     * To be able to insert badges, the app must have the PROVIDER_INSERT_BADGE
     * permission in the manifest file. In case these conditions are not
     * fulfilled, or any content values are missing, there will be an unhandled
     * exception on the background thread.
     *
     * @param badgeCount    the badge count
     * @param componentName the component name from which package and class name will be extracted
     */
    private ContentValues createContentValues(final int badgeCount, final ComponentName componentName) {
        final ContentValues contentValues = new ContentValues();
        contentValues.put(PROVIDER_COLUMNS_BADGE_COUNT, badgeCount);
        contentValues.put(PROVIDER_COLUMNS_PACKAGE_NAME, componentName.getPackageName());
        contentValues.put(PROVIDER_COLUMNS_ACTIVITY_NAME, componentName.getClassName());
        return contentValues;
    }

    /**
     * Check if the latest Asus badge content provider exists.
     *
     * @param context the context to use
     * @return true if Asus badge content provider exists, otherwise false.
     */
    private static boolean asusBadgeContentProviderExists(Context context) {
        boolean exists = false;
        ProviderInfo info = context.getPackageManager().resolveContentProvider(ASUS_LAUNCHER_PROVIDER_NAME, 0);
        if (info != null) {
            exists = true;
        }
        return exists;
    }
}
