import 'dart:io';
import 'dart:typed_data';

import 'package:chat_media_editor/chat_media_editor.dart';
import 'package:flutter/material.dart';

import 'file_item.dart';
import 'image_item.dart';
import 'video_item.dart';

class MediaItem extends StatelessWidget {
  final VoidCallback onCloseClicked;
  final Function(BaseMediaRes item) onDelete;
  final Function(BaseMediaRes item) onCrop;
  final Function(BaseMediaRes item) onStartDraw;
  final Function(BaseMediaRes item) onPlayVideo;
  final bool isProcessing;

  final BaseMediaRes mediaFile;

  const MediaItem({
    super.key,
    required this.mediaFile,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
    required this.isProcessing,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    if (isProcessing) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(),
        ],
      );
    }

    if (mediaFile is MediaImageRes) {
      return ImageItem(
        image: mediaFile as MediaImageRes,
        onCloseClicked: onCloseClicked,
        onCrop: onCrop,
        onDelete: onDelete,
        onStartDraw: onStartDraw,
      );
    }

    if (mediaFile is MediaVideoRes) {
      return VideoItem(
        video: mediaFile as MediaVideoRes,
        onCloseClicked: onCloseClicked,
        onPlayVideo: onPlayVideo,
        onDelete: onDelete,
      );
    }

    return FileItem(
      file: mediaFile as MediaFileRes,
      onCloseClicked: onCloseClicked,
      onDelete: onDelete,
    );
  }

  Widget getImage() {
    const BoxFit fit = BoxFit.contain;

    if (mediaFile is MediaImageRes) {
      final m = mediaFile as MediaImageRes;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.fileSource.fileLocalPath!),
          fit: fit,
        );
      }
      if (m.data.isFromBytes) {
        return Image.memory(
          Uint8List.fromList(m.data.fileSource.bytes!),
          fit: fit,
        );
      }
    } else if (mediaFile is MediaVideoRes) {
      final m = mediaFile as MediaVideoRes;
      if (m.data.isFromPath) {
        return Image.file(
          File(m.data.thumbImage!.fileSource.fileLocalPath!),
          fit: fit,
        );
      }
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
    );
  }
}
