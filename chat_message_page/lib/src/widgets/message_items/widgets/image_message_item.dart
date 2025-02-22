import 'dart:ui';

import 'package:background_downloader/background_downloader.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

import '../shared/constraint_image.dart';
import '../shared/download_upload_widgets/message_downloader_circular_widget.dart';
import '../shared/download_upload_widgets/message_downloader_widget.dart';

class ImageMessageItem extends StatelessWidget {
  final VImageMessage message;
  final BoxFit? fit;

  const ImageMessageItem({
    super.key,
    this.fit,
    required this.message,
  });

  void _navigateToImageViewer(VImageMessage message, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toImageViewer(
      context,
      message.data.fileSource,
      !message.isOneSeen,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!VPlatforms.isMobile) {
      return GestureDetector(
        onTap: () => _navigateToImageViewer(message, context),
        child: VConstraintImage(
          data: message.data,
          fit: BoxFit.cover,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    return GestureDetector(
      onTap: !message.isFileDownloaded ? null : () => _navigateToImageViewer(message, context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          message.isFileDownloaded
              ? VConstraintImage(
                  data: message.data,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(12),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: VConstraintImage(
                      data: message.data,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

          ///download widgets
          if (message.isMessageHasProgress)
            MessageProgressCircularWidget(
              downloadProgress: message.progress,
              onCancel: () {
                FileDownloader().cancelTaskWithId(message.localId);
              },
            )
          else if (!message.isFileDownloaded)
            MessageDownloaderWidget(message: message),
        ],
      ),
    );
  }
}
