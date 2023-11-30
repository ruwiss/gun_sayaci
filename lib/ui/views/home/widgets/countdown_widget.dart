import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/models/models.dart';
import 'package:gunsayaci/ui/views/settings/settings_provider.dart';
import 'package:gunsayaci/utils/utils.dart';
import 'package:provider/provider.dart';

class CountdownWidget extends StatefulWidget {
  final DataModel dataModel;
  final int index;
  const CountdownWidget(
      {super.key, required this.dataModel, required this.index});

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  late Timer _timer;
  Map<String, int>? _countItems;

  void _setAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.index * 500),
    );

    CurvedAnimation curve = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCirc);

    _animation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(curve);

    _animationController.forward();
  }

  void _startCountDownTimer() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countItems == null) _setAnimations();
        final DateTime now = DateTime.now();
        if (NotificationHelper.checkDateIsAfter(widget.dataModel)) {
          final Duration difference = widget.dataModel.dateTime.difference(now);

          _countItems = {
            "day".tr(): difference.inDays,
            "hour".tr(): difference.inHours % 24,
            "minute".tr(): difference.inMinutes % 60,
            "second".tr(): difference.inSeconds % 60,
            "end": 0
          };
        } else {
          final Duration difference = now.difference(widget.dataModel.dateTime);

          _countItems = {
            "day".tr(): difference.inDays,
            "hour".tr(): difference.inHours % 24,
            "minute".tr(): difference.inMinutes % 60,
            "second".tr(): difference.inSeconds % 60,
            "end": 1
          };
        }
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
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        context.watch<SettingsProvider>().themeMode == ThemeMode.dark;
    return _countItems == null
        ? const SizedBox()
        : SlideTransition(
            position: _animation,
            child: Stack(
              children: [
                Container(
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
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.index != 0) const SizedBox(height: 100),
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
                _emojiAndTimeExpired(),
              ],
            ),
          );
  }

  Positioned _emojiAndTimeExpired() {
    final bool hasEmoji = widget.dataModel.emoji != null;
    final bool expired = _countItems != null && _countItems!["end"] == 1;

    return Positioned(
      right: 30,
      bottom: expired && hasEmoji
          ? 55
          : expired
              ? 90
              : 70,
      child: Column(
        children: [
          if (hasEmoji)
            CircleAvatar(
              backgroundColor: Colors.grey.withOpacity(.15),
              radius: 25,
              child: Text(
                widget.dataModel.emoji!,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          if (expired)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: const Text(
                "time-expired",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ).tr(),
            ),
        ],
      ),
    );
  }

  Padding _editButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: IconButton(
        onPressed: () {
          context.pushNamed('create',
              queryParameters: {'isFirst': '${widget.index == 0}'},
              extra: widget.dataModel);
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
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Row _countdownView(BuildContext context, bool isDarkMode) {
    return Row(
      children: _countItems!.entries
          .map(
            (e) => e.value == 0 && e.key != "second".tr() || e.key == "end"
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
