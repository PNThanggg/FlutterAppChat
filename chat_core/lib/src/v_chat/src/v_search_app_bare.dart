import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

class VSearchAppBare extends StatefulWidget {
  final VoidCallback onClose;
  final int delay;
  final Function(String value) onSearch;
  final bool requestFocus;
  final String searchLabel;

  const VSearchAppBare({
    super.key,
    required this.onClose,
    required this.searchLabel,
    this.delay = 500,
    required this.onSearch,
    this.requestFocus = true,
  });

  @override
  State<VSearchAppBare> createState() => _VSearchAppBareState();
}

class _VSearchAppBareState extends State<VSearchAppBare> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: context.theme.cardColor,
      middle: CupertinoSearchTextField(
        autofocus: widget.requestFocus,
        placeholder: widget.searchLabel,
        onChanged: onSearchChanged,
        style: context.textTheme.bodyLarge,
        onSubmitted: (t) {
          widget.onSearch(t);
        },
      ),
      automaticallyImplyMiddle: false,
      automaticallyImplyLeading: false,
      padding: const EdgeInsetsDirectional.all(0),
      trailing: TextButton(
        onPressed: widget.onClose,
        child: 'Close'.h6.regular.size(16),
      ),
    );
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: widget.delay), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
