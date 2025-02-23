import 'package:chat_core/chat_core.dart';
import 'package:chat_media_editor/chat_media_editor.dart';
import 'package:flutter/material.dart';

class FileItem extends StatelessWidget {
  final VMediaFileRes file;
  final VoidCallback onCloseClicked;
  final Function(VMediaFileRes item) onDelete;

  const FileItem({
    super.key,
    required this.file,
    required this.onCloseClicked,
    required this.onDelete,
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
                BackButton(
                  onPressed: onCloseClicked,
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 30,
                      onPressed: () => onDelete(file),
                      icon: const Icon(
                        PhosphorIconsLight.trash,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    PhosphorIconsLight.file,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  file.data.name.h6.semiBold.color(Colors.white),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
