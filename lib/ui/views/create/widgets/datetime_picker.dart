import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/ui/views/create/widgets/custom_box.dart';
import 'package:gunsayaci/common/utils/utils.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? editDateTime;
  final Function(DateTime) onChanged;
  const DateTimePicker({super.key, required this.onChanged, this.editDateTime});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  final _yearController = FixedExtentScrollController();
  final _monthController = FixedExtentScrollController();
  final _dayController = FixedExtentScrollController();

  List<FixedExtentScrollController> _scrollList = [];

  late List<int> _years;
  late List<int> _days;
  final List<String> _months = [
    "january".tr(),
    "february".tr(),
    "march".tr(),
    "april".tr(),
    "may".tr(),
    "june".tr(),
    "july".tr(),
    "august".tr(),
    "september".tr(),
    "october".tr(),
    "november".tr(),
    "december".tr(),
  ];

  DateTime _selectedDateTime = DateTime(2025);

  void _scrollAnimation() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        for (var i = 0; i < _scrollList.length; i++) {
          final ScrollController scroll = _scrollList[i];
          if (widget.editDateTime == null) {
            scroll.animateTo(
              38.0,
              curve: Curves.easeOut,
              duration: Duration(seconds: i + 1),
            );
          } else {
            final FixedExtentScrollController scroll = _scrollList[i];
            void animateTo(int index) => scroll.animateToItem(index,
                duration: Duration(seconds: i + 1), curve: Curves.easeOut);
            if (scroll == _yearController) {
              animateTo(_years.indexOf(widget.editDateTime!.year));
            } else if (scroll == _monthController) {
              animateTo(widget.editDateTime!.month - 1);
            } else if (scroll == _dayController) {
              animateTo(_days.indexOf(widget.editDateTime!.day));
            }
          }

          scroll.addListener(
            () {
              final int selectedIndex =
                  (scroll as FixedExtentScrollController).selectedItem;
              if (scroll == _yearController) {
                _selectedDateTime =
                    _selectedDateTime.copyWith(year: _years[selectedIndex]);
              } else if (scroll == _monthController) {
                _selectedDateTime =
                    _selectedDateTime.copyWith(month: selectedIndex + 1);
              } else if (scroll == _dayController) {
                _selectedDateTime =
                    _selectedDateTime.copyWith(day: _days[selectedIndex]);
              }
              widget.onChanged(_selectedDateTime);
            },
          );
        }
      },
    );
  }

  @override
  void initState() {
    _scrollList = [_yearController, _monthController, _dayController];
    if (widget.editDateTime != null) {
      _selectedDateTime = widget.editDateTime!;
    }
    _scrollAnimation();
    _years = List.generate(5, (index) => DateTime.now().year + index);
    _days = List.generate(31, (index) => index + 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBox(
      title: "pick-time".tr(),
      child: Column(
        children: [
          // Date Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _wheelView(
                controller: _yearController,
                items: _years,
              ),
              _wheelView(
                controller: _monthController,
                items: List.generate(12, (index) {
                  final String month = _months[index];
                  return month.length > 6 ? month.substring(0, 6) : month;
                }),
              ),
              _wheelView(
                controller: _dayController,
                items: _days,
              ),
            ],
          ),
          // Time Picker
          InkWell(
            onTap: () async {
              final TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                helpText: "time-helper".tr(),
                hourLabelText: "hour".tr(),
                minuteLabelText: "minute".tr(),
                cancelText: "cancel".tr(),
                confirmText: "confirm".tr(),
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (selectedTime != null) {
                _selectedDateTime = _selectedDateTime.copyWith(
                    hour: selectedTime.hour, minute: selectedTime.minute);
                setState(() {});
                widget.onChanged(_selectedDateTime);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 130,
              decoration: BoxDecoration(
                color: KColors.createPagePrimary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      _selectedDateTime.hour == 0 &&
                              _selectedDateTime.minute == 0
                          ? "pick-hour".tr()
                          : "${_selectedDateTime.hour}: ${_selectedDateTime.minute}",
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                  const Icon(Icons.more_time_rounded, color: Colors.white),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _wheelItem(dynamic value) {
    return Text(
      value.toString(),
      style: TextStyle(
        fontSize: value is String ? 16 : 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _wheelView(
      {required FixedExtentScrollController controller, required List items}) {
    return SizedBox(
      height: 150,
      width: 90,
      child: ListWheelScrollView(
        controller: controller,
        overAndUnderCenterOpacity: 0.6,
        physics: const FixedExtentScrollPhysics(),
        useMagnifier: true,
        magnification: 1.3,
        itemExtent: 38,
        diameterRatio: .8,
        squeeze: .9,
        children: List.generate(
          items.length,
          (index) => Container(
            width: 80,
            alignment: Alignment.center,
            color: Colors.white,
            child: _wheelItem(items[index]),
          ),
        ),
      ),
    );
  }
}
