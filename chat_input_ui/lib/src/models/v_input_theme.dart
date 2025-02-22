import 'package:chat_core/chat_core.dart';
import 'package:chat_platform/v_platform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VInputTheme extends ThemeExtension<VInputTheme> {
  final BoxDecoration containerDecoration;
  final InputDecoration textFieldDecoration;

  final Widget cameraIcon;
  final Widget fileIcon;
  final Widget emojiIcon;
  final Widget trashIcon;

  Widget? recordBtn;
  Widget? sendBtn;
  final TextStyle textFieldTextStyle;

  VInputTheme._({
    required this.containerDecoration,
    required this.textFieldDecoration,
    required this.recordBtn,
    required this.sendBtn,
    required this.textFieldTextStyle,
    required this.emojiIcon,
    required this.trashIcon,
    required this.fileIcon,
    required this.cameraIcon,
  });

  VInputTheme.light({
    this.containerDecoration = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    this.cameraIcon = const Icon(
      PhosphorIconsLight.camera,
      size: 26,
      color: Colors.blueAccent,
    ),
    this.trashIcon = const Icon(
      PhosphorIconsLight.trash,
      color: Colors.redAccent,
      size: 30,
    ),
    this.fileIcon = const Icon(
      PhosphorIconsLight.image,
      size: 26,
      color: Colors.grey,
    ),
    this.emojiIcon = const Icon(
      PhosphorIconsLight.smiley,
      size: 26,
      color: Colors.blueAccent,
    ),
    this.textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      fillColor: Colors.transparent,
    ),
    this.recordBtn,
    this.sendBtn,
    this.textFieldTextStyle = const TextStyle(height: 1.3),
  }) {
    recordBtn ??= Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: VPlatforms.isDeskTop ? Colors.grey : Colors.blueAccent,
      ),
      child: const Icon(
        PhosphorIconsLight.microphone,
        color: Colors.white,
      ),
    );
    sendBtn ??= Container(
      padding: const EdgeInsets.all(9),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueAccent,
      ),
      child: const Icon(
        Icons.send,
        size: 20,
        color: Colors.white,
      ),
    );
  }

  VInputTheme.dark({
    this.containerDecoration = const BoxDecoration(
      color: Color(0x1AFFFFFF),
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    this.trashIcon = const Icon(
      PhosphorIconsLight.trash,
      color: Colors.redAccent,
      size: 30,
    ),
    this.cameraIcon = const Icon(
      PhosphorIconsLight.camera,
      size: 26,
      color: Colors.blueAccent,
    ),
    this.fileIcon = const Icon(
      PhosphorIconsLight.imageSquare,
      size: 26,
      color: Colors.grey,
    ),
    this.emojiIcon = const Icon(
      PhosphorIconsLight.smiley,
      size: 26,
      color: Colors.blueAccent,
    ),
    this.textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      fillColor: Colors.transparent,
    ),
    this.recordBtn,
    this.textFieldTextStyle = const TextStyle(height: 1.3),
    this.sendBtn,
  }) {
    recordBtn ??= Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: VPlatforms.isDeskTop ? Colors.grey : Colors.blueAccent,
      ),
      child: const Icon(
        PhosphorIconsLight.microphone,
        color: Colors.white,
      ),
    );
    sendBtn ??= Container(
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryColor,
      ),
      child: const Icon(
        Icons.send_rounded,
        color: Colors.white,
      ),
    );
  }

  @override
  ThemeExtension<VInputTheme> lerp(ThemeExtension<VInputTheme>? other, double t) {
    if (other is! VInputTheme) {
      return this;
    }
    return this;
  }

  @override
  VInputTheme copyWith({
    BoxDecoration? containerDecoration,
    InputDecoration? textFieldDecoration,
    Widget? cameraIcon,
    Widget? fileIcon,
    Widget? emojiIcon,
    Widget? recordBtn,
    Widget? sendBtn,
    Widget? trashIcon,
    TextStyle? textFieldTextStyle,
  }) {
    return VInputTheme._(
      containerDecoration: containerDecoration ?? this.containerDecoration,
      textFieldDecoration: textFieldDecoration ?? this.textFieldDecoration,
      cameraIcon: cameraIcon ?? this.cameraIcon,
      fileIcon: fileIcon ?? this.fileIcon,
      trashIcon: trashIcon ?? this.trashIcon,
      emojiIcon: emojiIcon ?? this.emojiIcon,
      recordBtn: recordBtn ?? this.recordBtn,
      sendBtn: sendBtn ?? this.sendBtn,
      textFieldTextStyle: textFieldTextStyle ?? this.textFieldTextStyle,
    );
  }
}

extension VInputThemeExt on BuildContext {
  VInputTheme get vInputTheme {
    if (CupertinoTheme.of(this).brightness == Brightness.dark) {
      return VInputTheme.dark();
    } else {
      return VInputTheme.light();
    }
  }
}
