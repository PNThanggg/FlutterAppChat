import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_platform/v_platform.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

import '../../core/core.dart';
import '../video_editor/media_editor_video_player.dart';
import 'app_pick.dart';

class MediaEditorController extends ValueNotifier {
  MediaEditorController(this.platformFiles, this.config) : super(null) {
    _init();
  }

  final List<VPlatformFile> platformFiles;
  final mediaFiles = <BaseMediaRes>[];
  final MediaEditorConfig config;
  bool isLoading = true;
  bool isCompressing = false;

  int currentImageIndex = 0;

  final pageController = PageController();

  void onEmptyPress(BuildContext context) {
    Navigator.pop(context);
  }

  void onDelete(BaseMediaRes item, BuildContext context) {
    mediaFiles.remove(item);
    if (mediaFiles.isEmpty) {
      return Navigator.pop(context);
    }
    _updateScreen();
  }

  Future<void> onCrop(MediaImageRes item, BuildContext context) async {
    final res = await VAppPick.croppedImage(file: item.data.fileSource);
    item.data.fileSource = res!;
    _updateScreen();
  }

  Future onStartEditVideo(
    MediaVideoRes item,
    BuildContext context,
  ) async {
    // if (item.data.isFromPath) {
    //   final file = await Navigator.push(
    //     context,
    //     MaterialPageRoute<void>(
    //       builder: (BuildContext context) =>
    //           VideoEditor(file: File(item.data.fileSource.filePath!)),
    //     ),
    //   ) as File?;
    //   if (file != null) {
    //     item.data.fileSource.filePath = file.path;
    //   }
    // }
  }

  Future<void> onStartDraw(
    BaseMediaRes item,
    BuildContext context,
  ) async {
    if (item is MediaImageRes) {
      if (item.data.isFromBytes) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProImageEditor.memory(
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (bytes) async {
                  item.data.fileSource = VPlatformFile.fromBytes(
                    name: item.data.fileSource.name,
                    bytes: bytes,
                  );
                  _updateScreen();
                  Navigator.pop(context);
                },
              ),
              Uint8List.fromList(item.data.fileSource.bytes!),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProImageEditor.file(
              File(item.data.fileSource.fileLocalPath!),
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (bytes) async {
                  final path = (await getApplicationDocumentsDirectory()).path;
                  final x = join(
                    path,
                    "media",
                    "${DateTime.now().microsecondsSinceEpoch}.png",
                  );
                  final newFile = await File(x).writeAsBytes(bytes);
                  item.data.fileSource = VPlatformFile.fromPath(
                    fileLocalPath: newFile.path,
                  );
                  _updateScreen();

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        );
      }
    }
  }

  void close() {
    pageController.dispose();
  }

  void changeImageIndex(int index) {
    currentImageIndex = index;
    pageController.jumpToPage(index);
    for (final element in mediaFiles) {
      element.isSelected = false;
    }
    mediaFiles[index].isSelected = true;
    _updateScreen();
  }

  void _updateScreen() {
    notifyListeners();
  }

  Future _init() async {
    for (final f in platformFiles) {
      if (f.getMediaType == VSupportedFilesType.image) {
        final mImage = MediaImageRes(
          data: MessageImageData(
            fileSource: f,
            blurHash: null,
            width: -1,
            height: -1,
          ),
        );
        mediaFiles.add(mImage);
      } else if (f.getMediaType == VSupportedFilesType.video) {
        MessageImageData? thumb;
        if (f.fileLocalPath != null) {
          thumb = await _getThumb(f.fileLocalPath!);
        }
        final mFile = MediaVideoRes(
          data: MessageVideoData(
            fileSource: f,
            duration: -1,
            thumbImage: thumb,
          ),
        );
        mediaFiles.add(mFile);
      } else {
        mediaFiles.add(MediaFileRes(data: f));
      }
    }
    mediaFiles[0].isSelected = true;
    isLoading = false;
    _updateScreen();
    startCompressImagesIfNeed();
  }

  Future<MessageImageData?> _getThumb(String path) async {
    return MediaFileUtils.getVideoThumb(
      fileSource: VPlatformFile.fromPath(
        fileLocalPath: path,
      ),
    );
  }

  void onPlayVideo(BaseMediaRes item, BuildContext context) {
    if (item is MediaVideoRes) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MediaEditorVideoPlayer(
            platformFileSource: item.data.fileSource,
            appName: "media_editor",
          ),
        ),
      );
    }
  }

  Future<void> startCompressImagesIfNeed() async {
    for (final f in mediaFiles) {
      if (f is MediaImageRes) {
        f.data.fileSource = (await MediaFileUtils.compressImage(fileSource: f.data.fileSource));
      }
      _updateScreen();
    }
  }

  Future<void> onSubmitData(BuildContext context) async {
    isCompressing = true;
    _updateScreen();
    for (final media in mediaFiles) {
      if (media is MediaImageRes && media.data.isFromPath) {
        final data = await MediaFileUtils.getImageInfo(
          fileSource: media.data.fileSource,
        );
        media.data.width = data.image.width;
        media.data.height = data.image.height;
        media.data.blurHash = await MediaFileUtils.getBlurHash(media.data.fileSource);
      } else if (media is MediaImageRes && media.data.isFromBytes) {
        final data = await MediaFileUtils.getImageInfo(
          fileSource: media.data.fileSource,
        );
        media.data.width = data.image.width;
        media.data.height = data.image.height;
      } else if (media is MediaVideoRes) {
        media.data.duration = await MediaFileUtils.getVideoDurationMill(media.data.fileSource);
      }
    }

    if (context.mounted) {
      Navigator.pop(context, mediaFiles);
    }
  }
}
