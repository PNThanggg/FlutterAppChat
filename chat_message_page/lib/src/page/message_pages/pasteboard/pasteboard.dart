import 'dart:async';

import 'package:chat_platform/v_platform.dart';
import 'package:universal_html/html.dart';

import 'file_convertor.dart';

abstract class IPasteboard {
  StreamSubscription<ClipboardEvent> pasteBoardListener(
    void Function(List<VPlatformFile> event) onData,
  );
}

class Pasteboard implements IPasteboard {
  Pasteboard(this.fileConvertor);

  final IFileConvertor fileConvertor;

  Future<VPlatformFile> _getVPlatformFileFromHtmlFile(File file) async {
    final result = await fileConvertor.htmlFileToBytes(file);
    return VPlatformFile.fromBytes(name: file.name, bytes: result);
  }

  @override
  StreamSubscription<ClipboardEvent> pasteBoardListener(
    void Function(List<VPlatformFile> event) onData,
  ) {
    return document.onPaste.listen((ClipboardEvent event) async {
      if (event.clipboardData == null ||
          event.clipboardData!.items == null ||
          event.clipboardData!.items!.length == null) {
        return;
      }
      final result = await _onClipboardEvent(event);
      onData(result);
    });
  }

  Future<List<VPlatformFile>> _onClipboardEvent(ClipboardEvent e) async {
    try {
      final clipboardItems = e.clipboardData!.items;
      final clipboardFiles = <File>[];
      for (var i = 0; i < clipboardItems!.length!; i++) {
        clipboardFiles.add(clipboardItems[i].getAsFile()!);
      }
      final data = await Future.wait(clipboardFiles.map((e) => _getVPlatformFileFromHtmlFile(e)).toList());
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
