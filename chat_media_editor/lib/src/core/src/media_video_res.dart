import 'package:chat_platform/v_platform.dart';

import 'base_media_res.dart';
import 'message_video_data.dart';

class MediaVideoRes extends BaseMediaRes {
  MessageVideoData data;

  MediaVideoRes({
    String? id,
    required this.data,
  }) : super(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        );

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;

  @override
  String toString() {
    return 'MediaEditorVideo{data $data}';
  }
}
