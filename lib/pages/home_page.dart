import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gunsayaci/locator.dart';
import 'package:gunsayaci/services/backend/database_service.dart';
import 'package:gunsayaci/services/models/data_model.dart';
import 'package:gunsayaci/services/providers/home_provider.dart';
import 'package:gunsayaci/widgets/features/home/countdown_widget.dart';
import 'package:gunsayaci/widgets/global/action_icon_button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _dataFetch = false;

  @override
  void initState() {
    locator.get<DatabaseService>().getAllDatas().then((value) {
      setState(() => _dataFetch = true);
      FlutterNativeSplash.remove();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataModelList = Provider.of<HomeProvider>(context).dataModelList;
    if (dataModelList.isEmpty && _dataFetch) _firstLoginNavigate();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gün Sayacı"),
        actions: [
          ActionIconButton(
            iconData: Icons.add,
            onTap: () {
              Navigator.of(context).pushNamed(
                "/create",
                arguments: (isFirst: dataModelList.isEmpty, dataModel: null),
              );
            },
          ),
          ActionIconButton(
              iconData: Icons.settings,
              onTap: () => Navigator.of(context).pushNamed("/settings")),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: dataModelList.isEmpty
            ? const Align(
                alignment: Alignment.center, child: Text("Bekleyiniz"))
            : Stack(
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
      ),
    );
  }

  void _firstLoginNavigate() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.popAndPushNamed(context, "/create",
            arguments: (isFirst: true, dataModel: null));
      },
    );
  }
}
