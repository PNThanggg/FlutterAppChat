import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/material.dart';

class VImagePicker extends StatefulWidget {
  final bool withCrop;
  final bool isFromCamera;
  final void Function(VPlatformFile file) onDone;
  final double size;
  final VPlatformFile initImage;

  const VImagePicker({
    super.key,
    this.withCrop = true,
    this.isFromCamera = false,
    required this.onDone,
    required this.initImage,
    this.size = 70.0,
  });

  @override
  State<VImagePicker> createState() => _VImagePickerState();
}

class _VImagePickerState extends State<VImagePicker> {
  late VPlatformFile current;

  @override
  void initState() {
    super.initState();
    current = widget.initImage;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PlatformCacheImageWidget(
            source: current,
            borderRadius: BorderRadius.circular(130),
            fit: BoxFit.cover,
            size: Size.fromHeight(widget.size),
          ),
          PositionedDirectional(
            bottom: 1,
            end: 1,
            child: GestureDetector(
              onTap: _getImage,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black87,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getImage() async {
    if (!widget.withCrop) {
      final image = await VAppPick.getImage(
        isFromCamera: widget.isFromCamera,
      );
      if (image == null) return;
      setState(() {
        current = image;
      });
      widget.onDone(image);
      return;
    }
    final image = await VAppPick.getCroppedImage(
      isFromCamera: widget.isFromCamera,
    );
    if (image == null) return;
    setState(() {
      current = image;
    });
    widget.onDone(image);
  }
}
