import 'package:flutter/material.dart';
import 'package:gunsayaci/utils/colors.dart';

class CustomBox extends StatelessWidget {
  final String title;
  final Widget child;
  const CustomBox({Key? key, required this.title, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: KColors.customBoxTitleGradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
              ),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            ),
            child,
          ],
        ));
  }
}
