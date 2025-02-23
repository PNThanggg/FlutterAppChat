import 'dart:io';
import 'dart:typed_data';

import 'package:chat_media_editor/chat_media_editor.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HorizontalMediaItem extends StatelessWidget {
  final BaseMediaRes mediaFile;
  final bool isLoading;

  const HorizontalMediaItem({
    super.key,
    required this.mediaFile,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 45,
      decoration: !mediaFile.isSelected
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(1),
              border: Border.all(
                color: Colors.red,
                width: 2,
              ),
            ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (isLoading && mediaFile is MediaVideoRes) const SizedBox.shrink() else getImage(),
          if (mediaFile is MediaVideoRes)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  PhosphorIconsLight.videoCamera,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget getImage() {
    const fit = BoxFit.cover;
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
        if(m.data.thumbImage != null) {
          return Image.file(
            File(m.data.thumbImage!.fileSource.fileLocalPath!),
            fit: fit,
          );
        }
      }
      return Container(
        color: Colors.black,
      );
    }
    return Container(
      color: Colors.black,
      child: const Icon(
        PhosphorIconsLight.file,
        color: Colors.white,
      ),
    );
  }
}
