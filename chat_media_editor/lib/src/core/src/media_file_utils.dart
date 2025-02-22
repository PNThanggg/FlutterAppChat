import 'dart:async';
import 'dart:io';

import 'package:blurhash/blurhash.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_win/video_player_win.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'message_image_data.dart';

abstract class VMediaFileUtils {
  static Future<MessageImageData?> getVideoThumb({
    required VPlatformFile fileSource,
    int maxWidth = 600,
    int quality = 50,
  }) async {
    if (!VPlatforms.isMobile) {
      return null;
    }

    if (fileSource.isFromBytes || fileSource.isFromUrl) {
      return null;
    }

    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: fileSource.fileLocalPath!,
      maxWidth: maxWidth,
      quality: quality,
    );

    if (thumbPath == null) {
      return null;
    }

    final thumbImageData = await getImageInfo(
      fileSource: VPlatformFile.fromPath(
        fileLocalPath: thumbPath,
      ),
    );

    return MessageImageData(
      fileSource: VPlatformFile.fromPath(fileLocalPath: thumbPath),
      width: thumbImageData.image.width,
      blurHash: await getBlurHash(VPlatformFile.fromPath(fileLocalPath: thumbPath)),
      height: thumbImageData.image.height,
    );
  }

  static Future<String?> getBlurHash(
    VPlatformFile fileSource,
  ) async {
    if (kIsWeb) return null;
    try {
      final data = File(fileSource.fileLocalPath!).readAsBytesSync();
      var blurHash = await BlurHash.encode(
        data,
        1,
        1,
      );
      return blurHash;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return null;
    }
  }

  static Future<int?> getVideoDurationMill(VPlatformFile file) async {
    if (file.isFromPath) {
      if (VPlatforms.isAndroid) {
        WinVideoPlayerController controller = WinVideoPlayerController.file(
          File(file.fileLocalPath!),
        );
        await controller.initialize();
        final value = controller.value.duration.inMilliseconds;
        controller.dispose();
        return value;
      } else {
        VideoPlayerController controller = VideoPlayerController.file(
          File(file.fileLocalPath!),
        );
        await controller.initialize();
        final value = controller.value.duration.inMilliseconds;
        controller.dispose();
        return value;
      }
    }
    return null;
  }

  //This is a function called "compressImage" that takes in a VPlatformFile object representing an image file and compresses it
  // if it is larger than a certain size (specified by the "compressAt" parameter). The compression is done using the FlutterNativeImage
  // library, which takes in the file path of the image and a quality parameter (defaulting to 50). If the resulting file is smaller than the specified size,
  // the original file is returned. Otherwise, the compressed file is returned as a new VPlatformFile object.
  static Future<VPlatformFile> compressImage({
    required VPlatformFile fileSource,
    int compressAt = 1500 * 1000,
    int quality = 50,
  }) async {
    if (!fileSource.isFromPath) {
      return fileSource;
    }
    VPlatformFile compressedFileSource = fileSource;
    if (compressedFileSource.fileSize > compressAt) {
      // compress only images bigger than 1500 kb
      final compressedFile = await FlutterNativeImage.compressImage(
        fileSource.fileLocalPath!,
        quality: quality,
        //targetWidth: 700,
        // targetHeight: (properties.height! * 700 / properties.width!).round(),
      );
      compressedFileSource = VPlatformFile.fromPath(fileLocalPath: compressedFile.path);
    }
    return compressedFileSource;
  }

  static Future<ImageInfo> getImageInfo({
    required VPlatformFile fileSource,
  }) async {
    final Image image = fileSource.isFromBytes
        ? Image.memory(Uint8List.fromList(fileSource.bytes!))
        : Image.file(File(fileSource.fileLocalPath!));
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) => completer.complete(info));
    image.image.resolve(const ImageConfiguration()).addListener(listener);
    return completer.future;
  }
}
