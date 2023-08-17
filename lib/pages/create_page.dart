import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/services/backend/database_service.dart';
import 'package:gunsayaci/services/models/data_model.dart';
import 'package:gunsayaci/utils/colors.dart';
import 'package:gunsayaci/utils/images.dart';
import 'package:gunsayaci/utils/strings.dart';
import 'package:gunsayaci/widgets/features/create/custom_box.dart';
import 'package:gunsayaci/widgets/features/create/datetime_picker.dart';
import 'package:gunsayaci/widgets/global/action_icon_button.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? _appBarTitle;
  DateTime? _selectedDate;
  int _selectedColorIndex = -1;
  final _titleController = TextEditingController();
  final String _titleHint =
      KStrings.dumpTitleList[Random().nextInt(KStrings.dumpTitleList.length)];

  bool _autoReplacementWorked = false;

  Widget _colorWidget(int index) {
    return InkWell(
      onTap: () => setState(() => _selectedColorIndex = index),
      child: Container(
        width: 25,
        height: 25,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: KColors.widgetColors[index],
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
                color:
                    _selectedColorIndex != index ? Colors.grey : Colors.white,
                width: _selectedColorIndex != index ? 1 : 1.5)),
      ),
    );
  }

  void _alarmPermission() async {
    await Permission.scheduleExactAlarm.request();
    await Permission.notification.request();
  }

  @override
  void initState() {
    _alarmPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ({
      bool isFirst,
      DataModel? dataModel
    });
    final bool isEdit = args.dataModel != null;
    if (isEdit && !_autoReplacementWorked) {
      _autoReplaceDataModel(args.dataModel!);
    }
    return Scaffold(
      backgroundColor: KColors.createPageBackground,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_appBarTitle ?? "create".tr()),
        actions: [
          if (isEdit && !args.isFirst)
            ActionIconButton(
              iconData: Icons.remove_circle,
              onTap: () {
                locator
                    .get<DatabaseService>()
                    .removeData(args.dataModel!.id!)
                    .then((_) => Navigator.of(context).pop());
              },
            ),
          ActionIconButton(
            iconData: Icons.check_circle,
            onTap: () {
              if (_titleController.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "title-error".tr(), toastLength: Toast.LENGTH_LONG);
                return;
              }
              DataModel dataModel = DataModel(
                  dateTime: _selectedDate!,
                  title: _titleController.text,
                  color: _selectedColorIndex);

              _submitData(
                  context: context,
                  dataModel: dataModel,
                  isEdit: isEdit,
                  id: args.dataModel?.id!);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(KImages.createImage),
            DateTimePicker(
              editDateTime: args.dataModel?.dateTime,
              onChanged: (DateTime dateTime) => _selectedDate = dateTime,
            ),
            CustomBox(
              title: "title-info".tr(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: _titleController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      hintText: _titleHint,
                      hintStyle: const TextStyle(color: Colors.black54),
                      isDense: true,
                      border: InputBorder.none),
                ),
              ),
            ),
            if (!args.isFirst)
              CustomBox(
                title: "color-info".tr(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    KColors.widgetColors.length,
                    (index) => _colorWidget(index),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void _autoReplaceDataModel(DataModel dataModel) {
    _titleController.text = dataModel.title;
    _selectedDate = dataModel.dateTime;
    _selectedColorIndex = dataModel.color;
    _appBarTitle = "edit".tr();
    _autoReplacementWorked = true;
    setState(() {});
  }

  void _submitData({
    required BuildContext context,
    required DataModel dataModel,
    int? id,
    bool isEdit = false,
  }) async {
    final navigator = Navigator.of(context);
    final modalRoute = ModalRoute.of(context);
    final DatabaseService databaseService = locator.get<DatabaseService>();
    if (isEdit) {
      await databaseService.updateData(id: id!, dataModel: dataModel);
      navigator.pop();
    } else {
      await databaseService.insertData(dataModel);
      if (modalRoute!.isFirst) {
        navigator.popAndPushNamed("/");
      } else {
        navigator.pop();
      }
    }
  }
}
