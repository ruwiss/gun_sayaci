import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gunsayaci/services/models/data_model.dart';
import '../../../utils/colors.dart';

class CountdownWidget extends StatefulWidget {
  final DataModel dataModel;
  final int index;
  const CountdownWidget(
      {Key? key, required this.dataModel, required this.index})
      : super(key: key);

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  late Timer _timer;
  Map<String, int>? _countItems;

  final _textShadow = const [
    Shadow(
      offset: Offset(-1, 0),
      blurRadius: 3.0,
      color: Colors.black12,
    ),
  ];

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
                      ? KColors.baseColor
                      : KColors.widgetColors[widget.dataModel.color],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 0),
                        blurRadius: 20,
                        spreadRadius: 2),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.index != 0) const SizedBox(height: 100),
                  _countItems!["Bitti"] == 1
                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Süre Doldu",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Row(
                          children: _countItems!.entries
                              .map(
                                (e) => e.value == 0 && e.key != "Saniye"
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                e.value.toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                        fontSize: 26,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        shadows: _textShadow),
                                              ),
                                              Text(
                                                e.key,
                                                style: TextStyle(
                                                  letterSpacing: 1.2,
                                                  fontSize: 11,
                                                  color: KColors.softText,
                                                ),
                                              )
                                            ],
                                          ),
                                          if (e.key != "Saniye")
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16,
                                                  left: 5,
                                                  right: 5),
                                              child: Text(
                                                ":",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: _textShadow),
                                              ),
                                            )
                                        ],
                                      ),
                              )
                              .toList(),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.dataModel.title,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/create",
                                  arguments: (
                                    isFirst: widget.index == 0,
                                    dataModel: widget.dataModel
                                  ));
                            },
                            icon: const Icon(Icons.edit_note),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _startCountDownTimer() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final DateTime now = DateTime.now();
        final Duration difference = widget.dataModel.dateTime.difference(now);

        _countItems = {
          "Gün": difference.inDays,
          "Saat": difference.inHours % 24,
          "Dakika": difference.inMinutes % 60,
          "Saniye": difference.inSeconds % 60,
          "Bitti": difference.isNegative ? 1 : 0,
        };
        setState(() {});
      });
    });
  }
}
