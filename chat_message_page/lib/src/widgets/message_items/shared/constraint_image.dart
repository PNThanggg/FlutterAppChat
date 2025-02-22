import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:v_chat_message_page/src/v_chat/platform_cache_image_widget.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart';

class VConstraintImage extends StatelessWidget {
  final VMessageImageData data;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  const VConstraintImage({
    super.key,
    required this.data,
    this.borderRadius,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: width < 600 ? height * .60 : height * .30,
        maxWidth: width < 600 ? width * .72 : width * .40,
      ),
      child: AspectRatio(
        aspectRatio: data.width / data.height,
        child: VPlatformCacheImageWidget(
          source: data.fileSource,
          borderRadius: borderRadius,
          fit: fit,
        ),
      ),
    );
  }
}

class VConstraintHashBlurImage extends StatelessWidget {
  final VMessageImageData data;

  const VConstraintHashBlurImage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: width < 600 ? height * .60 : height * .30,
        maxWidth: width < 600 ? width * .72 : width * .40,
      ),
      child: AspectRatio(
        aspectRatio: data.width / data.height,
        child: data.blurHash == null
            ? Container(
                color: Colors.black,
                child: const SizedBox(),
              )
            : BlurHash(
                imageFit: BoxFit.cover,
                hash: data.blurHash!,
              ),
      ),
    );
  }
}
