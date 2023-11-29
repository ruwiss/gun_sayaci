import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:gunsayaci/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/ui/theme.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:gunsayaci/ui/widgets/widgets.dart';
import 'package:gunsayaci/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'widgets/widgets.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key, this.dataModel, this.isFirst = false});
  final DataModel? dataModel;
  final bool isFirst;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  void _alarmPermission() async => await Permission.notification.request();

  @override
  void initState() {
    _alarmPermission();
    context.read<CreateProvider>().init(widget.dataModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = widget.dataModel != null;
    return Consumer<CreateProvider>(builder: (context, model, child) {
      return Scaffold(
        backgroundColor: KColors.createPageBackground,
        appBar: AppBar(
          centerTitle: true,
          title: Text(model.appBarTitle),
          backgroundColor:
              context.isDarkTheme ? null : KColors.createPageBackground,
          leading: widget.isFirst && !isEdit ? const SizedBox() : null,
          actions: [
            if (isEdit && !widget.isFirst)
              ActionIconButton(
                iconData: Icons.remove_circle,
                onTap: () async {
                  await locator<DatabaseService>()
                      .removeData(widget.dataModel!.id!);
                  if (mounted) context.pop();
                },
              ),
            ActionIconButton(
              iconData: Icons.check_circle,
              onTap: () async {
                if (model.titleController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "title-error".tr(), toastLength: Toast.LENGTH_LONG);
                  return;
                }
                await model.submitData();
                if (mounted) context.pop(true);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(KImages.createImage),
              DateTimePicker(
                editDateTime: widget.dataModel?.dateTime,
                onChanged: (DateTime dateTime) => model.selectedDate = dateTime,
              ),
              CustomBox(
                title: "title-info".tr(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: model.titleController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                        hintText: KStrings.getRandomTimerHint(),
                        hintStyle: const TextStyle(color: Colors.black54),
                        isDense: true,
                        border: InputBorder.none),
                  ),
                ),
              ),
              if (!widget.isFirst)
                CustomBox(
                  title: "color-info".tr(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      context.isDarkTheme
                          ? KColors.widgetColorsDark.length
                          : KColors.widgetColorsLight.length,
                      (index) => ColorWidget(index: index),
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
