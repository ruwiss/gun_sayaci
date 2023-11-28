import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gunsayaci/common/models/models.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';
import 'package:provider/provider.dart';
import '../../../../common/utils/colors.dart';

class CountdownWidget extends StatefulWidget {
  final DataModel dataModel;
  final int index;
  const CountdownWidget(
      {super.key, required this.dataModel, required this.index});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  Map<String, int>? _countItems;

  void _startCountDownTimer() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final DateTime now = DateTime.now();
        final Duration difference = widget.dataModel.dateTime.difference(now);

        _countItems = {
          "day".tr(): difference.inDays,
          "hour".tr(): difference.inHours % 24,
          "minute".tr(): difference.inMinutes % 60,
          "second".tr(): difference.inSeconds % 60,
          "end": difference.isNegative ? 1 : 0,
        };
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    _startCountDownTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        context.watch<SettingsProvider>().themeMode == ThemeMode.dark;
    return AnimatedOpacity(
      duration: Duration(milliseconds: widget.index * 100),
      opacity: _countItems != null ? 1 : 0,
      child: _countItems == null
          ? const SizedBox()
          : Container(
              padding: const EdgeInsets.only(left: 80, right: 5, top: 15),
              height: widget.index == 0 ? 140 : 240,
              decoration: BoxDecoration(
                color: widget.index == 0 || widget.dataModel.color == -1
                    ? isDarkMode
                        ? KColors.baseColorDark
                        : KColors.baseColorLight
                    : isDarkMode
                        ? KColors.widgetColorsDark[widget.dataModel.color]
                        : KColors.widgetColorsLight[widget.dataModel.color],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      blurRadius: 20,
                      spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.index != 0) const SizedBox(height: 100),
                  if (_countItems!["end"] == 1)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "time-expired",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ).tr(),
                    )
                  else
                    _countdownView(context, isDarkMode),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _titleView(),
                        _editButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Padding _editButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        onPressed: () {
          context.pushNamed('create', queryParameters: {'isFirst': '${widget.index == 0}'}, extra: widget.dataModel);
        },
        icon: const Icon(Icons.edit_note),
      ),
    );
  }

  Flexible _titleView() {
    return Flexible(
      child: Text(
        widget.dataModel.title,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  Row _countdownView(BuildContext context, bool isDarkMode) {
    return Row(
      children: _countItems!.entries
          .map(
            (e) => e.value == 0 && e.key != "second".tr()
                ? const SizedBox()
                : Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            e.value.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    shadows: _textShadow),
                          ),
                          Text(
                            e.key,
                            style: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 11,
                              color: isDarkMode
                                  ? KColors.softTextDark
                                  : KColors.softTextLight,
                            ),
                          )
                        ],
                      ),
                      if (e.key != "second".tr())
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16, left: 5, right: 5),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: _textShadow,
                            ),
                          ),
                        )
                    ],
                  ),
          )
          .toList(),
    );
  }

  final _textShadow = const [
    Shadow(
      offset: Offset(-1, 0),
      blurRadius: 3.0,
      color: Colors.black12,
    ),
  ];
}
