import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:universal_html/html.dart' as html;
import 'package:v_platform/v_platform.dart';

class VImageViewer extends StatefulWidget {
  final VPlatformFile platformFileSource;
  final String downloadingLabel;
  final String successfullyDownloadedInLabel;
  final bool showDownload;

  const VImageViewer({
    super.key,
    required this.platformFileSource,
    required this.downloadingLabel,
    required this.showDownload,
    required this.successfullyDownloadedInLabel,
  });

  @override
  State<VImageViewer> createState() => _VImageViewerState();
}

class _VImageViewerState extends State<VImageViewer> {
  Future<void> downloadImage(String imageUrl) async {
    try {
      // first we make a request to the url like you did
      // in the android and ios version
      final http.Response response = await http.get(
        Uri.parse(imageUrl),
      );

      // we get the bytes from the body
      final Uint8List data = response.bodyBytes;
      // and encode them to base64
      final String base64data = base64Encode(data);

      // then we create and AnchorElement with the html package
      final html.AnchorElement anchorElement = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');

      // set the name of the file we want the image to get
      // downloaded to
      anchorElement.download = imageUrl.split('/').last;

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: _getImageProvider(),
      ),
      floatingActionButton: !widget.showDownload
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: () async {
                await vSafeApiCall(
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
                      final path = await DefaultCacheManager().getSingleFile(widget.platformFileSource.url!);
                      await Gal.putImage(path.path);

                      if (context.mounted) {
                        return " ${S.of(context).currentDevice}";
                      }
                    }

                    if (VPlatforms.isWeb) {
                      await downloadImage(widget.platformFileSource.url!);

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
                  onError: (exception, trace) {
                    if (kDebugMode) {
                      print(exception);
                    }
                  },
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
      // floatingActionButton: !widget.platformFileSource.isContentImage
      //     ? null
      //     : !widget.showDownload
      //         ? const SizedBox.shrink()
      //         : FloatingActionButton(
      //             child: const Icon(Icons.save_alt),
      //             onPressed: () async {
      //               await vSafeApiCall(
      //                 onLoading: () {
      //                   VAppAlert.showSuccessSnackBar(
      //                     message: widget.downloadingLabel,
      //                     context: context,
      //                   );
      //                 },
      //                 request: () async {
      //                   if (VPlatforms.isMobile) {
      //                     if (!await Gal.hasAccess()) {
      //                       await Gal.requestAccess();
      //                     }
      //                     final path = await DefaultCacheManager().getSingleFile(widget.platformFileSource.url!);
      //                     await Gal.putImage(path.path);
      //
      //                     if (context.mounted) {
      //                       return " ${S.of(context).currentDevice}";
      //                     }
      //                   }
      //                   return VFileUtils.saveFileToPublicPath(
      //                     fileAttachment: widget.platformFileSource,
      //                   );
      //                 },
      //                 onSuccess: (url) async {
      //                   VAppAlert.showSuccessSnackBar(
      //                     message: widget.successfullyDownloadedInLabel + url,
      //                     context: context,
      //                   );
      //                 },
      //                 onError: (exception, trace) {
      //                   if (kDebugMode) {
      //                     print(exception);
      //                   }
      //                 },
      //               );
      //             },
      //           ),
    );

    // return Dismissible(
    //   key: const Key('photo_view_gallery'),
    //   direction: DismissDirection.down,
    //   onDismissed: (direction) {
    //     Navigator.of(context).pop();
    //   },
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.transparent,
    //     ),
    //     body: PhotoView(
    //       imageProvider: _getImageProvider(),
    //     ),
    //     floatingActionButton: !widget.showDownload
    //         ? const SizedBox.shrink()
    //         : FloatingActionButton(
    //             child: const Icon(Icons.save_alt),
    //             onPressed: () async {
    //               await vSafeApiCall(
    //                 onLoading: () {
    //                   VAppAlert.showSuccessSnackBar(
    //                     message: widget.downloadingLabel,
    //                     context: context,
    //                   );
    //                 },
    //                 request: () async {
    //                   if (VPlatforms.isMobile) {
    //                     if (!await Gal.hasAccess()) {
    //                       await Gal.requestAccess();
    //                     }
    //                     final path = await DefaultCacheManager().getSingleFile(widget.platformFileSource.url!);
    //                     await Gal.putImage(path.path);
    //
    //                     if (context.mounted) {
    //                       return " ${S.of(context).currentDevice}";
    //                     }
    //                   }
    //                   return VFileUtils.saveFileToPublicPath(
    //                     fileAttachment: widget.platformFileSource,
    //                   );
    //                 },
    //                 onSuccess: (url) async {
    //                   VAppAlert.showSuccessSnackBar(
    //                     message: widget.successfullyDownloadedInLabel + url,
    //                     context: context,
    //                   );
    //                 },
    //                 onError: (exception, trace) {
    //                   if (kDebugMode) {
    //                     print(exception);
    //                   }
    //                 },
    //               );
    //             },
    //           ),
    //     // floatingActionButton: !widget.platformFileSource.isContentImage
    //     //     ? null
    //     //     : !widget.showDownload
    //     //         ? const SizedBox.shrink()
    //     //         : FloatingActionButton(
    //     //             child: const Icon(Icons.save_alt),
    //     //             onPressed: () async {
    //     //               await vSafeApiCall(
    //     //                 onLoading: () {
    //     //                   VAppAlert.showSuccessSnackBar(
    //     //                     message: widget.downloadingLabel,
    //     //                     context: context,
    //     //                   );
    //     //                 },
    //     //                 request: () async {
    //     //                   if (VPlatforms.isMobile) {
    //     //                     if (!await Gal.hasAccess()) {
    //     //                       await Gal.requestAccess();
    //     //                     }
    //     //                     final path = await DefaultCacheManager().getSingleFile(widget.platformFileSource.url!);
    //     //                     await Gal.putImage(path.path);
    //     //
    //     //                     if (context.mounted) {
    //     //                       return " ${S.of(context).currentDevice}";
    //     //                     }
    //     //                   }
    //     //                   return VFileUtils.saveFileToPublicPath(
    //     //                     fileAttachment: widget.platformFileSource,
    //     //                   );
    //     //                 },
    //     //                 onSuccess: (url) async {
    //     //                   VAppAlert.showSuccessSnackBar(
    //     //                     message: widget.successfullyDownloadedInLabel + url,
    //     //                     context: context,
    //     //                   );
    //     //                 },
    //     //                 onError: (exception, trace) {
    //     //                   if (kDebugMode) {
    //     //                     print(exception);
    //     //                   }
    //     //                 },
    //     //               );
    //     //             },
    //     //           ),
    //   ),
    // );
  }

  ImageProvider _getImageProvider() {
    if (widget.platformFileSource.isFromPath) {
      return FileImage(File(widget.platformFileSource.fileLocalPath!));
    }

    if (widget.platformFileSource.isFromBytes) {
      return MemoryImage(Uint8List.fromList(widget.platformFileSource.bytes!));
    }

    return CachedNetworkImageProvider(
      widget.platformFileSource.url!,
      cacheKey: widget.platformFileSource.getUrlPath,
    );
  }
}
