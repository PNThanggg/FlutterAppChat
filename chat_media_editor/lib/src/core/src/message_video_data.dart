import 'package:chat_platform/v_platform.dart';

import 'message_image_data.dart';

class MessageVideoData {
  VPlatformFile fileSource;
  MessageImageData? thumbImage;
  int? duration;

  Duration? get durationObj => duration == null ? null : Duration(milliseconds: duration!);

  String? get durationFormat {
    if (durationObj == null) return null;
    return '$durationObj'.split('.')[0].padLeft(8, '0');
  }

  MessageVideoData({
    required this.fileSource,
    this.thumbImage,
    required this.duration,
  });

  bool get isFromPath => fileSource.fileLocalPath != null;

  bool get isFromBytes => fileSource.bytes != null;

  @override
  String toString() {
    return 'MessageVideoData{fileSource: $fileSource, thumbImageSource: $thumbImage, duration: $duration}';
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'duration': duration,
      'thumbImage': thumbImage?.toMap(),
    };
  }

  factory MessageVideoData.fromMap(Map<String, dynamic> map) {
    return MessageVideoData(
      fileSource: VPlatformFile.fromMap(map),
      duration: map['duration'] as int?,
      thumbImage: map['thumbImage'] == null
          ? null
          : MessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
            ),
    );
  }
}
