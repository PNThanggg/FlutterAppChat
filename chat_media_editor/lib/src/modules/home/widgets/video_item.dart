import 'package:chat_core/chat_core.dart';
import 'package:chat_media_editor/chat_media_editor.dart';
import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  final MediaVideoRes video;
  final VoidCallback onCloseClicked;
  final Function(MediaVideoRes item) onDelete;
  final Function(MediaVideoRes item) onPlayVideo;

  const VideoItem({
    super.key,
    required this.video,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onPlayVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  onPressed: () => onCloseClicked(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(video),
                      icon: const Icon(
                        PhosphorIconsLight.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              video.data.thumbImage != null
                  ? PlatformCacheImageWidget(
                      source: video.data.thumbImage!.fileSource,
                    )
                  : Container(
                      color: Colors.black87,
                    ),
              InkWell(
                onTap: () => onPlayVideo(video),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: const Icon(
                        PhosphorIconsLight.play,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
