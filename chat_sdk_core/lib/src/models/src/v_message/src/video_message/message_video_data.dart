import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:v_platform/v_platform.dart';

class VMessageVideoData {
  /// The file source data
  VPlatformFile fileSource;

  /// The thumb image data
  VMessageImageData? thumbImage;

  /// The duration of the video
  int? duration;

  Duration? get durationObj =>
      duration == null ? null : Duration(milliseconds: duration!);

  String? get durationFormat {
    if (durationObj == null) return null;
    return '$durationObj'.split('.')[0].padLeft(8, '0');
  }

  VMessageVideoData({
    required this.fileSource,
    required this.duration,
    this.thumbImage,
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

  factory VMessageVideoData.fromMap(Map<String, dynamic> map) {
    return VMessageVideoData(
      fileSource: VPlatformFile.fromMap(
        map,
      ),
      duration: map['duration'] as int?,
      thumbImage: map['thumbImage'] == null
          ? null
          : VMessageImageData.fromMap(
              map['thumbImage'] as Map<String, dynamic>,
            ),
    );
  }
}
