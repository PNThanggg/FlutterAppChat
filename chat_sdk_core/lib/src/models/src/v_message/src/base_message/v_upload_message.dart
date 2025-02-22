import 'package:v_platform/v_platform.dart';

abstract class VUploadMessage {
  VPlatformFile get fileSource;

  String get localFilePathWithExt;
}
