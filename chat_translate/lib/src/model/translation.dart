part of '../google_translator.dart';

/// Translation returned from GoogleTranslator.translate method, containing the translated text, the source text, the translated language and the source language
abstract class Translation {
  late final String text;
  late final String source;
  late final Language targetLanguage;
  late final Language sourceLanguage;

  Translation._(
    this.text,
    this.source,
    this.sourceLanguage,
    this.targetLanguage,
  );

  String operator +(other);

  @override
  String toString() => text;
}

class _Translation extends Translation {
  @override
  final String text;
  @override
  final String source;
  @override
  final Language sourceLanguage;
  @override
  final Language targetLanguage;

  _Translation(
    this.text, {
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.source,
  }) : super._(text, source, sourceLanguage, targetLanguage);

  @override
  String operator +(other) => toString() + other.toString();
}
