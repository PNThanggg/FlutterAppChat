import 'dart:typed_data';

import 'package:chat_core/chat_core.dart';
import 'package:flutter/material.dart';

class PasteImageDialog extends StatefulWidget {
  final Uint8List bytes;
  final Future<void> future;

  const PasteImageDialog({
    super.key,
    required this.bytes,
    required this.future,
  });

  @override
  State<PasteImageDialog> createState() => _PasteImageDialogState();
}

class _PasteImageDialogState extends State<PasteImageDialog> {
  bool _isLoadingSendPasteImage = false;

  final Color _mainColor = const Color(0xFF2774B0);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_isLoadingSendPasteImage) {
                        showToast(context, message: "Wait for the image to be sent");
                        return;
                      }

                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: _mainColor,
                      size: 24.0,
                    ),
                  ),
                  Expanded(
                    child: "1 Media".h6.alignCenter.size(14).color(_mainColor).semiBold,
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Image.memory(
                  widget.bytes,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.3 - 48,
                  height: MediaQuery.of(context).size.width * 0.3 - 48,
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      if (_isLoadingSendPasteImage) {
                        showToast(context, message: "The image is being sent");
                        return;
                      }

                      setState(() {
                        _isLoadingSendPasteImage = true;
                      });

                      widget.future.then((value) {
                        setState(() {
                          _isLoadingSendPasteImage = false;
                        });

                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    icon: _isLoadingSendPasteImage
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: _mainColor,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send,
                            size: 24,
                            color: _mainColor,
                          ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
