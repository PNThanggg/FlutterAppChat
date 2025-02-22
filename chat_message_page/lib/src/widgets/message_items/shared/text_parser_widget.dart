import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:super_up_core/super_up_core.dart';

class VTextParserWidget extends StatefulWidget {
  final Function(String email)? onEmailPress;
  final Function(String userId)? onMentionPress;
  final Function(String phone)? onPhonePress;
  final Function(String link)? onLinkPress;
  final bool enableTabs;
  final String text;
  final bool isOneLine;
  final TextStyle? textStyle;
  final TextStyle? emailTextStyle;
  final TextStyle? phoneTextStyle;
  final TextStyle? mentionTextStyle;

  const VTextParserWidget({
    super.key,
    this.onEmailPress,
    this.onMentionPress,
    this.onPhonePress,
    this.onLinkPress,
    this.enableTabs = false,
    this.isOneLine = false,
    required this.text,
    this.textStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.mentionTextStyle,
  });

  @override
  State<VTextParserWidget> createState() => _VTextParserWidgetState();
}

class _VTextParserWidgetState extends State<VTextParserWidget> {
  late String firstHalf;
  late String secondHalf;
  int maxWords = 400;
  bool isShowMoreEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > maxWords) {
      firstHalf = widget.text.substring(0, maxWords);
      secondHalf = widget.text.substring(maxWords, widget.text.length);
      isShowMoreEnabled = true;
    } else {
      firstHalf = widget.text;
      secondHalf = "";
      isShowMoreEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle blueTheme = context.textTheme.bodyLarge!.copyWith(
      color: Colors.blue,
      fontWeight: FontWeight.w400,
    );

    if (widget.isOneLine) {
      return _renderText(
        blueTheme: blueTheme,
        maxLine: 1,
        text: firstHalf,
      );
    }

    if (secondHalf.isEmpty) {
      return _renderText(
        blueTheme: blueTheme,
        text: firstHalf,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderText(
          blueTheme: blueTheme,
          text: isShowMoreEnabled ? "$firstHalf ..." : widget.text,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isShowMoreEnabled = !isShowMoreEnabled;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: isShowMoreEnabled
                ? const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.grey,
                  )
                : const Icon(
                    Icons.fullscreen_exit_rounded,
                    color: Colors.grey,
                  ),
          ),
        )
      ],
    );
  }

  String _trimUsername(String input) {
    RegExp pattern = RegExp(r'@\w{5,}(?!\w*\.)');
    return input.replaceAllMapped(pattern, (Match match) {
      String matchedString = match.group(0)!;
      return matchedString.substring(0, 5);
    });
  }

  Widget _renderText({
    required TextStyle blueTheme,
    required String text,
    int? maxLine,
  }) {
    String displayTest = _trimUsername(text);

    return IgnorePointer(
      ignoring: !widget.enableTabs,
      child: AutoDirection(
        text: displayTest,
        child: SelectableRegion(
          focusNode: FocusNode(),
          selectionControls: materialTextSelectionControls,
          child: ParsedText(
            text: displayTest,
            maxLines: maxLine,
            style: widget.textStyle,
            regexOptions: const RegexOptions(
              multiLine: true,
              dotAll: true,
            ),
            textWidthBasis: TextWidthBasis.longestLine,
            parse: [
              MatchText(
                pattern: r"\[(@[^:]+):([^\]]+)\]",
                style: blueTheme,
                renderText: ({
                  required String str,
                  required String pattern,
                }) {
                  final map = <String, String>{};
                  final match = VStringUtils.vMentionRegExp.firstMatch(str);
                  map['display'] = match!.group(1)!;
                  return map;
                },
                onTap: (url) {
                  final match = VStringUtils.vMentionRegExp.firstMatch(url)!;
                  final userId = match.group(2);
                  if (widget.onMentionPress != null && userId != null) {
                    widget.onMentionPress!(userId);
                  }
                },
              ),
              if (widget.onEmailPress != null)
                MatchText(
                  pattern: regexEmail,
                  style: blueTheme,
                  onTap: (url) {
                    widget.onEmailPress?.call(url);
                  },
                ),
              if (widget.onPhonePress != null)
                MatchText(
                    type: ParsedType.PHONE,
                    style: blueTheme,
                    onTap: (url) {
                      widget.onPhonePress!(url);
                    }),
              if (widget.onLinkPress != null)
                MatchText(
                  pattern: regexLink,
                  style: blueTheme,
                  onTap: (url) {
                    final protocolIdentifierRegex = RegExp(
                      r'^((http|ftp|https)://)',
                      caseSensitive: false,
                    );
                    if (!url.startsWith(protocolIdentifierRegex)) {
                      url = 'https://$url';
                    }
                    widget.onLinkPress?.call(url);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// class SworkCommentField extends StatefulWidget {
//   final String text;
//   final int trimLength;
//
//   const SworkCommentField({
//     super.key,
//     required this.text,
//     this.trimLength = 100,
//   });
//
//   @override
//   State createState() {
//     return _SworkCommentFieldState();
//   }
// }
//
// class _SworkCommentFieldState extends State<SworkCommentField> {
//   late String firstPart;
//   late String secondPart;
//   bool _isExpanded = false;
//   late String linkPreview;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.text.length > widget.trimLength) {
//       firstPart = widget.text.substring(0, widget.trimLength);
//       secondPart = widget.text.substring(widget.trimLength);
//     } else {
//       firstPart = widget.text;
//       secondPart = '';
//     }
//     //get link to preview meta display
//     linkPreview = _buildTextSpan(_isExpanded ? widget.text : firstPart)['link'];
//   }
//
//   Future<void> _launchURL(String url) async {
//     if (await canLaunchUrl(Uri.parse(url))) {
//       await launchUrl(Uri.parse(url));
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Map<String, dynamic> _buildTextSpan(String text) {
//     String link = "";
//     final urlPattern = RegExp(r'\bhttps?://[-\w+&@#/%?=~_|!:,.;]*', caseSensitive: false);
//     List<TextSpan> spans = [];
//     int lastMatchEnd = 0;
//     for (final match in urlPattern.allMatches(text)) {
//       final String startText = text.substring(lastMatchEnd, match.start);
//       final linkText = match.group(0);
//       if (link.isEmpty) link = linkText.validate();
//       spans.add(TextSpan(text: startText, style: primaryTextStyle()));
//       spans.add(
//         TextSpan(
//             text: linkText,
//             style: primaryTextStyle(color: primaryColor, decoration: TextDecoration.underline),
//             recognizer: TapGestureRecognizer()..onTap = () => _launchURL(linkText.validate())),
//       );
//       lastMatchEnd = match.end;
//     }
//     spans.add(TextSpan(text: text.substring(lastMatchEnd), style: primaryTextStyle()));
//     return {'link': link, 'text': spans};
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var text = _buildTextSpan(_isExpanded ? widget.text : firstPart)['text'];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(children: text),
//               if (widget.text.length >= widget.trimLength)
//                 TextSpan(
//                     text: _isExpanded ? " read less" : " ...read more",
//                     style: secondaryTextStyle(),
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = () {
//                         _isExpanded = !_isExpanded;
//                         setState(() {});
//                       })
//             ],
//           ),
//         ),
//         linkPreview.isEmptyOrNull
//             ? SizedBox(
//                 width: 0,
//                 height: 0,
//               )
//             : MetaDataDisplay(
//                 url: linkPreview,
//                 index: 0,
//                 isComment: true,
//               )
//       ],
//     );
//   }
// }
