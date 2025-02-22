import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_translation/generated/l10n.dart';
import 'package:super_up_core/super_up_core.dart' hide NoAnimationPageRoute;
import 'package:v_platform/v_platform.dart';

import '../../admin.dart';
import 'users_controller.dart';
import 'widget/search_text_field.dart';

class UsersTabNavigation extends StatelessWidget {
  const UsersTabNavigation({
    super.key,
  });

  static final navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      initialRoute: 'IdleUsersRoute',
      onGenerateRoute: (settings) {
        return NoAnimationPageRoute(
          fullscreenDialog: false,
          builder: (context) {
            return const UsersPage();
          },
        );
      },
    );
  }
}

class UsersPage extends StatefulWidget {
  static final navKey = GlobalKey<NavigatorState>();

  const UsersPage({
    super.key,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersController controller = UsersController();

  @override
  void initState() {
    super.initState();
    controller.onInit();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "User".h3.medium.size(20),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: SearchTextField(
              onSearch: controller.onSearch,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, value, __) {
                // return ListView.builder(
                //   itemCount: con,
                //   itemBuilder: (context, index) {},
                // );

                return SDataTable(
                  paginatorController: controller.paginatorController,
                  maxPages: controller.data.totalPages == 0 ? 1 : controller.data.totalPages,
                  loadingState: value.loadingState,
                  data: controller.data.values
                      .map(
                        (e) => DataRow(
                          cells: [
                            DataCell(
                              InkWell(
                                onTap: () => controller.onCopyId(context, e.id),
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return states.contains(WidgetState.focused) ? null : Colors.transparent;
                                  },
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.copy,
                                      color: Colors.indigo,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(child: Text(e.id)),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              InkWell(
                                onTap: () => controller.onUserTap(e.id),
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                    return states.contains(WidgetState.focused) ? null : Colors.transparent;
                                  },
                                ),
                                child: Row(
                                  children: [
                                    VCircleAvatar(
                                      vFileSource: VPlatformFile.fromUrl(
                                        url: e.userImage,
                                      ),
                                      radius: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: e.fullName.text.underline.color(Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                e.country == null ? "" : "${e.country!.emoji} ${e.country!.name}",
                              ),
                            ),
                            DataCell(Text(e.email)),
                            DataCell(Text(e.registerStatus)),
                            DataCell(
                              Text(
                                format(
                                  e.createdAt,
                                  locale: Localizations.localeOf(context).languageCode,
                                ),
                              ),
                            ),
                            DataCell(Text(
                              _getDateFromString(e.deletedAt) ?? S.of(context).none,
                            )),
                            DataCell(Text(_getDateFromString(e.banTo) ?? S.of(context).none)),
                          ],
                        ),
                      )
                      .toList(),
                  columns: [
                    DataColumn2(
                      label: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ID"),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(Icons.sort)
                        ],
                      ),
                      fixedWidth: 250,
                      onSort: (columnIndex, ascending) {
                        controller.toggleSort();
                      },
                    ),
                    DataColumn2(label: Text(S.of(context).name), fixedWidth: 200),
                    DataColumn2(label: Text(S.of(context).country), fixedWidth: 110),
                    DataColumn2(label: Text(S.of(context).email), fixedWidth: 150),
                    DataColumn2(label: Text(S.of(context).status), fixedWidth: 80),
                    DataColumn2(label: Text(S.of(context).joinedAt), fixedWidth: 100),
                    DataColumn2(label: Text(S.of(context).deletedAt)),
                    DataColumn2(label: Text(S.of(context).banAt)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String? _getDateFromString(String? str) {
    if (str == null) return null;
    return DateFormat.yMd(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.parse(str).toLocal());
  }
}
