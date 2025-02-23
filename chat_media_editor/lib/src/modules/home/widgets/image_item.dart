import 'package:chat_media_editor/chat_media_editor.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ImageItem extends StatelessWidget {
  final MediaImageRes image;
  final VoidCallback onCloseClicked;
  final Function(MediaImageRes item) onDelete;
  final Function(MediaImageRes item) onCrop;
  final Function(MediaImageRes item) onStartDraw;

  const ImageItem({
    super.key,
    required this.image,
    required this.onCloseClicked,
    required this.onDelete,
    required this.onCrop,
    required this.onStartDraw,
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
                  onPressed: onCloseClicked,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(image),
                      icon: const Icon(
                        PhosphorIconsLight.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        if (VPlatforms.isWeb) {
                          return;
                        }
                        onCrop(image);
                      },
                      icon: Icon(
                        PhosphorIconsLight.crop,
                        color: VPlatforms.isWeb ? Colors.grey : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    IconButton(
                      iconSize: 30,
                      onPressed: () {
                        onStartDraw(image);
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: VPlatformCacheImageWidget(
            source: image.data.fileSource,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
