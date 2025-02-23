import 'package:chat_platform/v_platform.dart';

import 'base_media_res.dart';
import 'message_image_data.dart';

class MediaImageRes extends BaseMediaRes {
  MessageImageData data;

  MediaImageRes({
    String? id,
    required this.data,
  }) : super(
          id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        );

  @override
  String toString() {
    return 'MediaEditorImage{data: $data}';
  }

  @override
  VPlatformFile getVPlatformFile() => data.fileSource;
}
