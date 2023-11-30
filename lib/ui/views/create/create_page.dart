import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/ui/theme.dart';
import 'package:gunsayaci/ui/views/create/create_provider.dart';
import 'package:gunsayaci/ui/views/create/widgets/emoji_picker.dart';
import 'package:gunsayaci/ui/widgets/widgets.dart';
import 'package:gunsayaci/utils/utils.dart';
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
  @override
  void initState() {
    NotificationHelper.permission();
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
            EmojiPicker(
              emoji: model.emoji,
              onChanged: (emoji) {
                model.selectEmoji(emoji);
              },
            ),
            if (isEdit && !widget.isFirst)
              CustomActionButton(
                iconData: Icons.remove_circle,
                onTap: () async {
                  await locator<DatabaseService>()
                      .removeData(widget.dataModel!);
                  if (mounted) context.pop();
                },
              ),
            CustomActionButton(
              iconData: Icons.check_circle,
              onTap: () async {
                if (model.titleController.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "title-error".tr(), toastLength: Toast.LENGTH_LONG);
                  return;
                }
                if (await model.submitData() && mounted) context.pop(true);
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
                ),
              const SizedBox(height: 10),
              if (model.bannerAd != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: SizedBox(
                    width: model.bannerAd!.size.width.toDouble(),
                    height: model.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: model.bannerAd!),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}
