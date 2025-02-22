import 'package:flutter/material.dart';

class ThemedText extends StatelessWidget {
  const ThemedText({
    super.key,
    required this.data,
    this.style,
    this.extra,
  });

  final String data;
  final TextStyle Function(TextTheme)? style;
  final Map<String, dynamic>? extra;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style!(Theme.of(context).textTheme).copyWith(letterSpacing: 0),
      overflow: extra?["overflow"],
      maxLines: extra?["maxLine"],
      softWrap: extra?["softWrap"],
      textAlign: extra?["textAlign"],
      textScaler: extra?["textScaleFactor"],
    );
  }

  ThemedText textless<T>(T v) => (v is Map) ? styled(extra: v) : styled(style: v as TextStyle);

  ThemedText styled({
    TextStyle? style,
    Map? extra,
  }) =>
      ThemedText(
        data: data,
        style: (tt) => this.style!(tt).merge(style),
        extra: {
          ...?this.extra,
          ...?extra,
        },
      );

  ThemedText get lineThrough => textless(
        const TextStyle(
          decoration: TextDecoration.lineThrough,
        ),
      );

  ThemedText get underline => textless(
        const TextStyle(
          decoration: TextDecoration.underline,
        ),
      );

  ThemedText get overline => textless(
        const TextStyle(
          decoration: TextDecoration.overline,
        ),
      );

  ThemedText color(Color v) => textless(
        TextStyle(
          color: v,
        ),
      );

  ThemedText backgroundColor(Color v) => textless(
        TextStyle(
          backgroundColor: v,
        ),
      );

  ThemedText size(double v) => textless(
        TextStyle(
          fontSize: v,
        ),
      );

  ThemedText height(double v) => textless(
        TextStyle(
          height: v,
        ),
      );

  ThemedText get italic => textless(
        const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      );

  ThemedText get thin => textless(
        const TextStyle(
          fontWeight: FontWeight.w100,
        ),
      );

  ThemedText get extraLight => textless(
        const TextStyle(
          fontWeight: FontWeight.w200,
        ),
      );

  ThemedText get light => textless(
        const TextStyle(
          fontWeight: FontWeight.w300,
        ),
      );

  ThemedText get regular => textless(
        const TextStyle(
          fontWeight: FontWeight.normal,
        ),
      );

  ThemedText get medium => textless(
        const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      );

  ThemedText get semiBold => textless(
        const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      );

  ThemedText get bold => textless(
        const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      );

  ThemedText get extraBold => textless(
        const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      );

  ThemedText get black => textless(
        const TextStyle(
          fontWeight: FontWeight.w900,
        ),
      );

  ThemedText get solidLine => textless(
        const TextStyle(
          decorationStyle: TextDecorationStyle.solid,
        ),
      );

  ThemedText get dottedLine => textless(
        const TextStyle(
          decorationStyle: TextDecorationStyle.dotted,
        ),
      );

  ThemedText get doubledLine => textless(
        const TextStyle(
          decorationStyle: TextDecorationStyle.double,
        ),
      );

  ThemedText get wavyLine => textless(
        const TextStyle(
          decorationStyle: TextDecorationStyle.wavy,
        ),
      );

  ThemedText get dashedLine => textless(
        const TextStyle(
          decorationStyle: TextDecorationStyle.dashed,
        ),
      );

  ThemedText lineColor(Color v) => textless(
        TextStyle(
          decorationColor: v,
        ),
      );

  ThemedText lineThickness(double v) => textless(
        TextStyle(
          decorationThickness: v,
        ),
      );

  ThemedText get alphabeticBaseline => textless(
        const TextStyle(
          textBaseline: TextBaseline.alphabetic,
        ),
      );

  ThemedText get ideographicBaseline => textless(
        const TextStyle(
          textBaseline: TextBaseline.ideographic,
        ),
      );

  ThemedText fontFamily(String v) => textless(
        TextStyle(
          fontFamily: v,
        ),
      );

  ThemedText letterSpacing(double v) => textless(
        TextStyle(
          letterSpacing: v,
        ),
      );

  ThemedText wordSpacing(double v) => textless(
        TextStyle(
          wordSpacing: v,
        ),
      );

  ThemedText locale(Locale v) => textless(
        TextStyle(
          locale: v,
        ),
      );

  ThemedText foreground(Paint v) => textless(
        TextStyle(
          foreground: v,
        ),
      );

  ThemedText shadows(List<Shadow> v) => textless(
        TextStyle(
          shadows: v,
        ),
      );

  ThemedText fontFeatures(List<FontFeature> v) => textless(
        TextStyle(
          fontFeatures: v,
        ),
      );

  ThemedText softWrap(bool v) => textless({"softWrap": v});

  ThemedText get overflowVisible => textless({"overflow": TextOverflow.visible});

  ThemedText get overflowClip => textless({"overflow": TextOverflow.clip});

  ThemedText get overflowEllipsis => textless({"overflow": TextOverflow.ellipsis});

  ThemedText get overflowFade => textless({"overflow": TextOverflow.fade});

  ThemedText maxLine(int v) => textless({"maxLine": v});

  ThemedText scaleFactor(double v) => textless({"textScaleFactor": v});

  ThemedText get alignLeft => textless({"textAlign": TextAlign.left});

  ThemedText get alignRight => textless({"textAlign": TextAlign.right});

  ThemedText get alignCenter => textless({"textAlign": TextAlign.center});

  ThemedText get alignJustify => textless({"textAlign": TextAlign.justify});

  ThemedText get alignStart => textless({"textAlign": TextAlign.start});

  ThemedText get alignEnd => textless({"textAlign": TextAlign.end});
}

extension PaddingOnNumb on num {
  EdgeInsetsGeometry get pl => EdgeInsets.only(left: toDouble());

  EdgeInsetsGeometry get pr => EdgeInsets.only(right: toDouble());

  EdgeInsetsGeometry get pt => EdgeInsets.only(top: toDouble());

  EdgeInsetsGeometry get pb => EdgeInsets.only(bottom: toDouble());

  EdgeInsetsGeometry get p => EdgeInsets.all(toDouble());
}

extension ThemedTextStyle on ThemedText {}

extension TextLess on String {
  ThemedText style(TextStyle style) => ThemedText(data: this, style: (t) => style);

  ThemedText get text => ThemedText(data: this, style: (t) => const TextStyle());

  ThemedText get h1 => ThemedText(data: this, style: (t) => t.displayLarge!);

  ThemedText get h2 => ThemedText(data: this, style: (t) => t.displayMedium!);

  ThemedText get h3 => ThemedText(data: this, style: (t) => t.displaySmall!);

  ThemedText get h4 => ThemedText(data: this, style: (t) => t.headlineLarge!);

  ThemedText get h5 => ThemedText(data: this, style: (t) => t.headlineMedium!);

  ThemedText get h6 => ThemedText(data: this, style: (t) => t.headlineSmall!);

  ThemedText get s1 => ThemedText(data: this, style: (t) => t.titleMedium!);

  ThemedText get s2 => ThemedText(data: this, style: (t) => t.titleSmall!);

  ThemedText get b1 => ThemedText(data: this, style: (t) => t.bodyLarge!);

  ThemedText get b2 => ThemedText(data: this, style: (t) => t.bodyMedium!);

  ThemedText get btn => ThemedText(data: this, style: (t) => t.labelLarge!);

  ThemedText get cap => ThemedText(data: this, style: (t) => t.bodySmall!);

  ThemedText get ol => ThemedText(data: this, style: (t) => t.labelSmall!);
}
