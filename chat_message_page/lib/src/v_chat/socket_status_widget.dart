import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/material.dart';

class SocketStatusWidget extends StatefulWidget {
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final String connectingLabel;

  final Duration delay;

  const SocketStatusWidget({
    super.key,
    this.decoration = const BoxDecoration(color: Colors.amber),
    this.padding = const EdgeInsets.all(5),
    required this.connectingLabel,
    this.delay = const Duration(seconds: 5),
  });

  @override
  State<SocketStatusWidget> createState() => _SocketStatusWidgetState();
}

class _SocketStatusWidgetState extends State<SocketStatusWidget> {
  final _socket = VChatController.I.nativeApi.remote.socketIo;
  bool show = false;

  @override
  void initState() {
    _delay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!show) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<VSocketStatusEvent>(
      stream: VChatController.I.nativeApi.streams.socketStatusStream,
      initialData: VSocketStatusEvent(
        isConnected: _socket.isConnected,
        connectTimes: 0,
      ),
      builder: (context, snapshot) {
        if (!snapshot.data!.isConnected) {
          return Container(
            decoration: widget.decoration,
            child: Padding(
              padding: widget.padding,
              child: Text(
                widget.connectingLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _delay() async {
    await Future.delayed(widget.delay);
    if (mounted) {
      setState(() {
        show = true;
      });
    }
  }
}
