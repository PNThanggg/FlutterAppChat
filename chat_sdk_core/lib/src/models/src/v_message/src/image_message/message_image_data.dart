import 'package:v_platform/v_platform.dart';

class VMessageImageData {
  VPlatformFile fileSource;
  int width;
  int height;
  String? blurHash;

  VMessageImageData({
    required this.fileSource,
    required this.width,
    required this.height,
    required this.blurHash,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VMessageImageData &&
          runtimeType == other.runtimeType &&
          fileSource == other.fileSource &&
          width == other.width &&
          height == other.height);

  @override
  int get hashCode => fileSource.hashCode ^ width.hashCode ^ height.hashCode;

  @override
  String toString() {
    return 'MessageImageData{ fileSource: $fileSource, width: $width, height: $height,}';
  }

  bool get isFromPath => fileSource.fileLocalPath != null;

  bool get isFromBytes => fileSource.bytes != null;

  VMessageImageData copyWith({
    VPlatformFile? fileSource,
    int? width,
    int? height,
    String? blurHash,
  }) {
    return VMessageImageData(
      fileSource: fileSource ?? this.fileSource,
      width: width ?? this.width,
      height: height ?? this.height,
      blurHash: blurHash ?? this.blurHash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      ...fileSource.toMap(),
      'width': width,
      'height': height,
      'blurHash': blurHash,
    };
  }

  factory VMessageImageData.fromMap(Map<String, dynamic> map) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromMap(
        map,
      ),
      width: map['width'] as int,
      height: map['height'] as int,
      blurHash: map['blurHash'] as String?,
    );
  }

  factory VMessageImageData.fromFakeData({
    required int high,
    required int width,
  }) {
    return VMessageImageData(
      fileSource: VPlatformFile.fromUrl(
        url: "https://picsum.photos/$width/$high",
      ),
      width: width,
      blurHash: null,
      height: high,
    );
  }
}
