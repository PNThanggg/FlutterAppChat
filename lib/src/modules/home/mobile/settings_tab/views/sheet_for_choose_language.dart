import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart';

class SheetForChooseLanguage extends StatefulWidget {
  const SheetForChooseLanguage({super.key});

  @override
  State<SheetForChooseLanguage> createState() => _SheetForChooseLanguageState();
}

class _SheetForChooseLanguageState extends State<SheetForChooseLanguage> {
  final txtController = TextEditingController();

  var _languages = <ModelSheetItem>[];

  @override
  void initState() {
    super.initState();
    _addLanguage();
  }

  List<ModelSheetItem> get _supportedLocales {
    return S.delegate.supportedLocales.map(
      (e) {
        return ModelSheetItem(
          id: e.languageCode,
          title: getFullLanguageName(e.languageCode),
        );
      },
    ).toList();
  }

  void _addLanguage() {
    _languages = _supportedLocales;
  }

  @override
  void dispose() {
    super.dispose();
    txtController.dispose();
  }

  @override
  Widget build(BuildContext contextParent) {
    return Navigator(
      onGenerateRoute: (___) => CupertinoPageRoute(
        builder: (__) => CupertinoPageScaffold(
          backgroundColor: contextParent.theme.cardColor,
          navigationBar: CupertinoNavigationBar(
            border: const Border.fromBorderSide(BorderSide.none),
            backgroundColor: contextParent.theme.highlightColor,
            leading: TextButton(
              onPressed: Navigator.of(contextParent).pop,
              child: Text(S.of(context).close),
            ),
            middle: Text(S.of(context).language, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: CupertinoSearchTextField(
                      controller: txtController,
                      onChanged: onSearchChanged,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: ModalScrollController.of(context),
                      padding: const EdgeInsets.all(5),
                      separatorBuilder: (context, index) => Divider(
                        height: 10,
                        thickness: 1,
                        color: Colors.grey.withOpacity(.2),
                      ),
                      itemBuilder: (context, index) {
                        final item = _languages[index];
                        return CupertinoListTile(
                          onTap: () {
                            Navigator.of(contextParent).pop(item);
                          },
                          title: getFullLanguageName(item.title).text.regular.size(16).color(Theme.of(context).textTheme.bodyLarge!.color!),
                        );
                      },
                      itemCount: _languages.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSearchChanged(String value) {
    if (value.isEmpty) {
      _addLanguage();
    } else {
      _languages = _supportedLocales.where((e) => e.title.toLowerCase().startsWith(value.toLowerCase())).toList();
    }

    setState(() {});
  }
}
