import 'package:v_platform/v_platform.dart';

abstract class VDownloadableMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;

  bool get isFileDownloaded;
}
