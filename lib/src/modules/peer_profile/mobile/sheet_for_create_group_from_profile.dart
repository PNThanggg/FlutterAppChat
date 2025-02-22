import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';
import 'package:v_platform/v_platform.dart';

import '../../create_group/views/create_group_view.dart';

class SheetForCreateGroupFromProfile extends StatelessWidget {
  final SBaseUser peer;

  const SheetForCreateGroupFromProfile({
    super.key,
    required this.peer,
  });

  @override
  Widget build(BuildContext context) {
    if (VPlatforms.isIOS) {
      return Navigator(
        onGenerateRoute: (rootContext) => CupertinoPageRoute(
          builder: (_) {
            return CreateGroupView(
              users: [peer],
              onDone: (vRoom) {
                Navigator.of(context).pop(vRoom);
              },
            );
          },
        ),
      );
    }
    return Navigator(
      onGenerateRoute: (rootContext) => MaterialPageRoute(
        builder: (_) {
          return CreateGroupView(
            users: [peer],
            onDone: (vRoom) {
              Navigator.of(context).pop(vRoom);
            },
          );
        },
      ),
    );
  }
}
