import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gunsayaci/services/models/datetime_model.dart';
import 'package:gunsayaci/utils/colors.dart';
import 'package:gunsayaci/widgets/features/create/custom_box.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime? editDateTime;
  final Function(DateTime) onChanged;
  const DateTimePicker({Key? key, required this.onChanged, this.editDateTime})
      : super(key: key);

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

final _yearController = FixedExtentScrollController();
final _monthController = FixedExtentScrollController();
final _dayController = FixedExtentScrollController();

final List scrollList = [_yearController, _monthController, _dayController];

late List<int> _years;
late List<int> _days;
List<String> _months = [
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

DateTimeModel _selectedDateTime = DateTimeModel.empty();

class _DateTimePickerState extends State<DateTimePicker> {
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

  @override
  void initState() {
    if (widget.editDateTime != null) {
      _selectedDateTime = DateTimeModel.convert(widget.editDateTime!);
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
                _selectedDateTime.hour = selectedTime.hour;
                _selectedDateTime.minute = selectedTime.minute;
                setState(() {});
                widget.onChanged(_selectedDateTime.createDateTime());
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

  void _scrollAnimation() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (var i = 0; i < scrollList.length; i++) {
        final ScrollController scroll = scrollList[i];
        if (widget.editDateTime == null) {
          scroll.animateTo(
            38.0,
            curve: Curves.easeOut,
            duration: Duration(seconds: i + 1),
          );
        } else {
          final FixedExtentScrollController scroll = scrollList[i];
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

        scroll.addListener(() {
          final int selectedIndex =
              (scroll as FixedExtentScrollController).selectedItem;
          if (scroll == _yearController) {
            _selectedDateTime.year = _years[selectedIndex];
          } else if (scroll == _monthController) {
            _selectedDateTime.month = selectedIndex + 1;
          } else if (scroll == _dayController) {
            _selectedDateTime.day = _days[selectedIndex];
          }
          widget.onChanged(_selectedDateTime.createDateTime());
        });
      }
    });
  }
}
