import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VCircleAvatar extends StatelessWidget {
  final int radius;
  final String fullUrl;

  const VCircleAvatar({
    super.key,
    this.radius = 28,
    required this.fullUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.grey.shade200,
      radius: double.tryParse(radius.toString()),
      backgroundImage: CachedNetworkImageProvider(
        fullUrl,
      ),
    );
  }
}
