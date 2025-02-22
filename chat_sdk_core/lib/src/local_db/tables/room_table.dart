import 'package:sqflite/sqflite.dart';

class RoomTable {
  RoomTable._();

  static const tableName = 'tb_r';
  static const columnId = '${tableName}_id';
  static const columnRoomType = '${tableName}_room_type';
  static const columnTitle = '${tableName}_title';
  static const columnThumbImage = '${tableName}_img';
  static const columnTransTo = '${tableName}_t_to';
  static const columnIsArchived = '${tableName}_is_archived';
  static const columnIsMuted = '${tableName}_is_muted';
  static const columnPeerId = '${tableName}_peer_id';
  static const columnBlockerId = '${tableName}_blocker_id';
  static const columnEnTitle = '${tableName}_title_en';
  static const columnUnReadCount = '${tableName}_un_counter';
  static const columnIsOneSeen = '${tableName}_is_one_seen';
  static const columnNickName = '${tableName}_nick_name';
  static const columnCreatedAt = '${tableName}_created_at';
  static const columnMentionsCount = '${tableName}_mentions_count';
  static const columnTelegramGroupId = '${tableName}_telegram_group_id';
  static Future<void> recreateTable(Transaction db) async {
    await db.execute(
      '''
          drop table if exists $tableName
        ''',
    );
    await RoomTable.createTable(db);
  }

  static Future<void> createTable(Transaction db) async {
    await db.execute(
      '''
          create table $tableName (
       
            $columnId     TEXT PRIMARY KEY UNIQUE ,
            $columnRoomType     TEXT   ,
            $columnTitle     TEXT   ,
            $columnEnTitle     TEXT   ,
            $columnThumbImage     TEXT   ,
            $columnTransTo     TEXT   ,
            $columnCreatedAt     TEXT   ,
            $columnIsArchived     INTEGER ,
            $columnIsOneSeen     INTEGER ,
            $columnMentionsCount   INTEGER,
            $columnIsMuted     INTEGER ,
            $columnPeerId     TEXT   ,
            $columnBlockerId     TEXT   ,
            $columnNickName     TEXT   ,
            $columnUnReadCount     INTEGER ,
            $columnTelegramGroupId     TEXT ,
           
         
            UNIQUE($columnId, $columnPeerId) ON CONFLICT REPLACE
            )        
          ''',
    );

    ///$columnIsTranslateEnable     INTEGER DEFAULT 0,
    await db.execute(
      '''
      CREATE INDEX idx_id_$tableName
      ON $tableName ($columnId)
    ''',
    );
  }
}
