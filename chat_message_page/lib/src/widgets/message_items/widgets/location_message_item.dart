import 'package:flutter/cupertino.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_chat_sdk_core/v_chat_sdk_core.dart' hide VStringUtils;

class LocationMessageItem extends StatelessWidget {
  final VLocationMessage message;

  const LocationMessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: CupertinoListTile(
        onTap: () async {
          await VStringUtils.lunchMap(
            latitude: message.data.latLng.latitude,
            longitude: message.data.latLng.longitude,
            title: message.data.linkPreviewData.title,
            description: message.data.linkPreviewData.description,
          );
        },
        leadingSize: 50,
        leadingToTitle: 10,
        padding: const EdgeInsets.all(10),
        leading: const Icon(
          CupertinoIcons.location,
          size: 40,
        ),
        title: message.data.linkPreviewData.title.toString().text,
        subtitle: message.data.linkPreviewData.description
            .toString()
            .text
            .maxLine(2)
            .overflowEllipsis,
      ),
    );
  }
}
