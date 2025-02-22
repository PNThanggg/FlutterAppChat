import 'package:chat_platform/v_platform.dart';

abstract class VDownloadableMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;

  bool get isFileDownloaded;
}
