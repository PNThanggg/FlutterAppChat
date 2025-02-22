import 'package:sqflite/sqflite.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class ApiCacheSqlImp extends BaseLocalApiCacheRepo {
  final Database _database;

  ApiCacheSqlImp(this._database);

  final table = ApiCacheTable.tableName;

  @override
  Future<ApiCacheModel?> getOneByEndPoint(String endpoint) async {
    final res = await _database.query(
      table,
      where: "${ApiCacheTable.columnId} =?",
      whereArgs: [endpoint],
      limit: 1,
    );
    if (res.isEmpty) {
      return null;
    }
    return ApiCacheModel.fromLocalMap(res.first);
  }

  @override
  Future<int> insert(ApiCacheModel model) {
    return _database.insert(
      table,
      model.toLocalMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> reCreate() {
    return _database.transaction((txn) => ApiCacheTable.recreateTable(txn));
  }
}
