import 'package:chat_sdk_core/chat_sdk_core.dart';

class VAppLifeCycle extends VAppEvent {
  final bool isGoBackground;

  const VAppLifeCycle({
    required this.isGoBackground,
  });

  @override
  List<Object?> get props => [isGoBackground];
}
