import 'package:chat_platform/v_platform.dart';

abstract class BaseMediaRes {
  bool isSelected = false;
  final String id;

  VPlatformFile getVPlatformFile();

  BaseMediaRes({
    required this.id,
  });

  @override
  bool operator ==(Object other) => other is BaseMediaRes && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
