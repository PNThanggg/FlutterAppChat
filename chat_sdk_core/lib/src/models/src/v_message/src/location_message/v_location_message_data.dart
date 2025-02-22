import 'package:latlong2/latlong.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

class VLocationMessageData {
  /// The location data
  final LatLng latLng;

  ///image preview data and title and description
  final VLinkPreviewData linkPreviewData;

  VLocationMessageData({
    required this.latLng,
    required this.linkPreviewData,
  });

  @override
  String toString() {
    return 'VLocationMessageData{latLng: $latLng, linkPreviewData: $linkPreviewData}';
  }

  VLocationMessageData.fromMap(Map<String, dynamic> json)
      : latLng = LatLng(
          double.parse(json['lat'].toString()),
          double.parse(json['long'].toString()),
        ),
        linkPreviewData = VLinkPreviewData.fromMap(
          json['linkPreviewData'] as Map<String, dynamic>,
        );

  Map<String, dynamic> toMap() => {
        'lat': latLng.latitude.toString(),
        'long': latLng.longitude.toString(),
        'linkPreviewData': linkPreviewData.toMap(),
      };
}
