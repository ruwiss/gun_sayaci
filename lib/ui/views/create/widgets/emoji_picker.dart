import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gunsayaci/ui/widgets/widgets.dart';
import 'package:gunsayaci/utils/utils.dart';

class EmojiPicker extends StatefulWidget {
  final String? emoji;
  final Function(String emoji)? onChanged;
  const EmojiPicker({super.key, required this.emoji, this.onChanged});

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  final _tInput = TextEditingController();
  final _tFocusNode = FocusNode();
  bool _input = false;

  void _enableInput() {
    _tInput.clear();
    Fluttertoast.showToast(
        msg: 'select-emoji'.tr(), gravity: ToastGravity.CENTER);
    setState(() => _input = true);
    _tFocusNode.requestFocus();
  }

  void _disableInput() {
    setState(() => _input = false);
    _tFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) =>
      _input ? _inputWidget() : _emojiWidget();

  SizedBox _inputWidget() {
    return SizedBox(
      width: 30,
      child: TextField(
        controller: _tInput,
        focusNode: _tFocusNode,
        onChanged: (t) {
          if (!t.isEmoji()) {
            _tInput.clear();
            return;
          }
          _disableInput();
          widget.onChanged?.call(t);
        },
        decoration: const InputDecoration(
          isDense: true,
          border: InputBorder.none,
        ),
      ),
    );
  }

  CustomActionButton _emojiWidget() {
    return CustomActionButton.emoji(
      emoji: widget.emoji ?? Strings.getDummyEmoji(),
      onTap: _enableInput,
    );
  }
}
