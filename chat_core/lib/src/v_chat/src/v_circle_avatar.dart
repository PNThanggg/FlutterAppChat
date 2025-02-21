import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:v_platform/v_platform.dart';

class VCircleAvatar extends StatelessWidget {
  final double radius;
  final VPlatformFile vFileSource;

  const VCircleAvatar({
    super.key,
    this.radius = 28.0,
    required this.vFileSource,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: radius,
      backgroundImage: CachedNetworkImageProvider(
        vFileSource.url!,
        cacheKey: vFileSource.getUrlPath,
      ),
    );
  }

  ImageProvider getImageProvider() {
    if (vFileSource.url != null) {
      return CachedNetworkImageProvider(vFileSource.url!);
    }
    if (vFileSource.isFromBytes) {
      return MemoryImage(vFileSource.uint8List);
    }

    if (vFileSource.isFromPath) {
      return FileImage(File(vFileSource.fileLocalPath!));
    } else {
      return CachedNetworkImageProvider(vFileSource.url!);
    }
  }
}

class VCircleVerifiedAvatar extends StatelessWidget {
  final double radius;
  final VPlatformFile vFileSource;

  const VCircleVerifiedAvatar({
    super.key,
    this.radius = 28,
    required this.vFileSource,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VCircleAvatar(
          vFileSource: vFileSource,
          radius: radius,
        ),
        PositionedDirectional(
          end: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const badges.Badge(
              badgeAnimation: badges.BadgeAnimation.fade(toAnimate: false),
              badgeContent: Icon(
                Icons.check,
                color: Colors.white,
                size: 7,
              ),
              badgeStyle: badges.BadgeStyle(
                shape: badges.BadgeShape.twitter,
                badgeColor: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
