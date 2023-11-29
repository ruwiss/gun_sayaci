import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:gunsayaci/common/models/models.dart';
import 'package:gunsayaci/core/core.dart';
import 'package:gunsayaci/ui/views/home/home_provider.dart';
import 'package:gunsayaci/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      locator<HomeProvider>().getAllDatas().then((value) {
        if (value.isEmpty && mounted) {
          context.pushNamed('create', queryParameters: {'isFirst': 'true'});
        }
        FlutterNativeSplash.remove();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeProvider>(context);
    final dataModelList = model.dataModelList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("app-name").tr(),
        actions: [
          ActionIconButton(
            iconData: Icons.add,
            onTap: () => context.pushNamed('create',
                queryParameters: {'isFirst': '${dataModelList.isEmpty}'}),
          ),
          ActionIconButton(
              iconData: Icons.settings,
              onTap: () => context.pushNamed('settings')),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: dataModelList.isEmpty
            ? Center(child: const Text("wait").tr())
            : Column(
                children: [
                  Stack(
                    children: [
                      Container(height: 140 * dataModelList.length + 10),
                      ...List.generate(
                        dataModelList.length,
                        (index) {
                          final DataModel dataModel = dataModelList[index];
                          double top = 0;
                          if (index == 1) {
                            top = 40;
                          } else if (index == 2) {
                            top = 180;
                          } else if (index != 0) {
                            top = 140 * (index - 2) + 180;
                          }
                          return Positioned(
                            top: top,
                            left: 0,
                            right: 0,
                            child: CountdownWidget(
                              index: index,
                              dataModel: dataModel,
                            ),
                          );
                        },
                      ).toList().reversed,
                    ],
                  ),
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
  }
}
