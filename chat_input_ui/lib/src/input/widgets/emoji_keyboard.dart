import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:chat_platform/v_platform.dart';

class EmojiKeyboard extends StatelessWidget {
  final bool isEmojiShowing;
  final TextEditingController controller;

  const EmojiKeyboard({
    super.key,
    required this.isEmojiShowing,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isEmojiShowing,
      child: SizedBox(
        height: VPlatforms.isWeb ? MediaQuery.of(context).size.height / 3 : 250,
        child: EmojiPicker(
          textEditingController: controller,
          onEmojiSelected: (category, emoji) {
            controller.text = controller.text + emoji.emoji;
          },
          config: Config(
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1F1F1F) // Dark mode background
                  : Colors.white, // Light mode background
            ),
            emojiViewConfig: EmojiViewConfig(
              noRecents: Text(
                'No Recents',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Colors.black,
                ),
              ),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xF90A0E17) // Dark mode background
                  : Colors.white, // Light mode background
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              buttonIconColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              buttonColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF061C3B) : Colors.white,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0E1723) // Dark mode background
                  : Colors.white, // Light mode background
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1F1F1F) // Dark mode background
                  : Colors.white, // Light mode background
            ),
          ),
        ),
      ),
    );
  }
}
