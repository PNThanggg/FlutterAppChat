import 'package:chat_platform/v_platform.dart';

import 'base_media_res.dart';

class MediaFileRes extends BaseMediaRes {
  VPlatformFile data;

  @override
  VPlatformFile getVPlatformFile() => data;

  MediaFileRes({
    String? id,
    required this.data,
  }) : super(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        );

  @override
  String toString() {
    return 'MediaEditorFile{data $data}';
  }
}
