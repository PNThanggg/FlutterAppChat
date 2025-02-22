import 'package:chat_platform/v_platform.dart';

abstract class VUploadMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;
}
