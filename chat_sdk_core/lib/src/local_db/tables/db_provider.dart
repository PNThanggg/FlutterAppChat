import 'dart:async';
import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class DBProvider {
  DBProvider._();

  static final instance = DBProvider._();

  final Completer<void> dbCompleter = Completer<void>();

  final log = Logger('DBProvider SQL');

  Database? _database;

  Future<Database?> get database async {
    if (VPlatforms.isWeb) {
      dbCompleter.complete();
      return null;
    }

    if (_database != null) {
      return _database!;
    }

    // if _database is null we instantiate it
    _database = await _open();
    return _database!;
  }

  Future<Database> _open() async {
    final Directory windowsApplicationDocument = await getApplicationDocumentsDirectory();
    final documentsDirectory =
        VPlatforms.isWindows ? windowsApplicationDocument.path : await getDatabasesPath();
    final path = join(documentsDirectory, VAppConstants.dbName);

    if (VPlatforms.isWindows) {
      return _initForWindows(path);
    }

    return openDatabase(
      path,
      version: VAppConstants.dbVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        await reCreateTables(db);
      },
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          await RoomTable.createTable(txn);
          await MessageTable.createTable(txn);
          await ApiCacheTable.createTable(txn);
        });
        log.fine("All tables Created !!");
      },
      onOpen: (db) async {
        dbCompleter.complete();
      },
    );
  }

  Future reCreateTables(Database db) async {
    await db.transaction(
      (txn) async {
        await RoomTable.recreateTable(txn);
        await MessageTable.recreateTable(txn);
        await ApiCacheTable.recreateTable(txn);
      },
    );

    log.warning("all tables deleted !!!!!!!!!!!!!!!!!!!!!!!!");
  }

  Future<Database> _initForWindows(String path) async {
    final databaseFactory = databaseFactoryFfi;
    return databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: VAppConstants.dbVersion,
        onUpgrade: (db, oldVersion, newVersion) async {
          await reCreateTables(db);
        },
        onCreate: (db, version) async {
          await db.transaction((txn) async {
            await RoomTable.createTable(txn);
            await MessageTable.createTable(txn);
            await ApiCacheTable.createTable(txn);
            log.fine("All tables Created !!");
          });
        },
        onOpen: (db) async {
          dbCompleter.complete();
        },
      ),
    );
  }
}
