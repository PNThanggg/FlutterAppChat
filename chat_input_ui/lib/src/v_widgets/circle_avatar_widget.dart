import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final int radius;
  final String fullUrl;

  const CircleAvatarWidget({
    super.key,
    this.radius = 28,
    required this.fullUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius.toDouble(),
      backgroundImage: CachedNetworkImageProvider(
        fullUrl,
      ),
    );
  }
}
