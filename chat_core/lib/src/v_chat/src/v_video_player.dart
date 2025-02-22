import 'dart:convert';
import 'dart:io';

import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:chat_translation/generated/l10n.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

class VVideoPlayer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String downloadingLabel;
  final bool showDownload;
  final String successfullyDownloadedInLabel;

  const VVideoPlayer({
    super.key,
    required this.platformFileSource,
    required this.downloadingLabel,
    required this.showDownload,
    required this.successfullyDownloadedInLabel,
  });

  @override
  State<VVideoPlayer> createState() => _VVideoPlayerState();
}

class _VVideoPlayerState extends State<VVideoPlayer> {
  bool isLoading = true;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initAndPlay();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
  }

  Future<void> downloadVideo(String videoUrl) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(videoUrl),
      );

      // we get the bytes from the body
      final Uint8List data = response.bodyBytes;
      // and encode them to base64
      final base64data = base64Encode(data);

      // then we create and AnchorElement with the html package
      final html.AnchorElement anchorElement = html.AnchorElement(
        href: 'data:image/jpeg;base64,$base64data',
      );

      // set the name of the file we want the image to get
      // downloaded to
      anchorElement.download = videoUrl.split('/').last;

      // and we click the AnchorElement which downloads the image
      anchorElement.click();
      // finally we remove the AnchorElement
      anchorElement.remove();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.platformFileSource.isContentVideo) {
      return Material(
        child: "The file must be video ${widget.platformFileSource}".h6.alignCenter,
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: !widget.showDownload
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: () async {
                await vSafeApiCall<String>(
                  onLoading: () {
                    VAppAlert.showSuccessSnackBar(
                      message: widget.downloadingLabel,
                      context: context,
                    );
                  },
                  request: () async {
                    if (VPlatforms.isMobile) {
                      if (!await Gal.hasAccess()) {
                        await Gal.requestAccess();
                      }
                      final File path =
                          await DefaultCacheManager().getSingleFile(widget.platformFileSource.networkUrl!);
                      await Gal.putVideo(path.path);
                      return " ${S.of(context).currentDevice}";
                    }

                    if (VPlatforms.isWeb) {
                      await downloadVideo(widget.platformFileSource.networkUrl!);

                      if (context.mounted) {
                        return " ${S.of(context).download}";
                      }
                    }

                    return VFileUtils.saveFileToPublicPath(
                      fileAttachment: widget.platformFileSource,
                    );
                  },
                  onSuccess: (url) async {
                    VAppAlert.showSuccessSnackBar(
                      message: widget.successfullyDownloadedInLabel + url,
                      context: context,
                    );
                  },
                  onError: (exception, trace) {},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.save_alt),
              ),
            ),
      body: SafeArea(
        child: Center(
          child: VConditionalBuilder(
            condition: !isLoading,
            thenBuilder: () => AspectRatio(
              aspectRatio: _videoPlayerController!.value.aspectRatio,
              child: Chewie(
                controller: _chewieController!,
              ),
            ),
            elseBuilder: () => const CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  void _initAndPlay() async {
    VideoPlayerController? controller;
    VideoPlayerOptions options = VideoPlayerOptions(allowBackgroundPlayback: false);
    if (widget.platformFileSource.isFromPath) {
      controller = VideoPlayerController.file(
        File(widget.platformFileSource.fileLocalPath!),
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromBytes) {
      controller = VideoPlayerController.contentUri(
        Uri.dataFromBytes(widget.platformFileSource.getBytes),
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromAssets) {
      controller = VideoPlayerController.asset(
        widget.platformFileSource.assetsPath!,
        videoPlayerOptions: options,
      );
    } else if (widget.platformFileSource.isFromUrl) {
      final file = await (VPlatforms.isMobile
          ? DefaultCacheManager().getSingleFile(
              widget.platformFileSource.networkUrl!,
              key: widget.platformFileSource.getCachedUrlKey,
            )
          : null);
      controller = file != null
          ? VideoPlayerController.file(file, videoPlayerOptions: options)
          : VideoPlayerController.networkUrl(
              Uri.parse(widget.platformFileSource.networkUrl!),
              videoPlayerOptions: options,
            );
    }

    if (controller != null) {
      await controller.initialize();
      setState(() {
        _videoPlayerController = controller;
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: true,
          looping: false,
        );
        isLoading = false;
      });
    }
  }
}
