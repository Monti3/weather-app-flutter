import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Padding additionalInfoItem(IconData icon, String text, String data) {
  return Padding(
    padding: const EdgeInsets.only(left: 0, right: 70),
    child: Column(children: [
      Icon(
        icon,
      ),
      Text(
        text,
      ),
      Text(
        data,
      )
    ]),
  );
}














class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const AdditionalInfoItem({
  super.key,
  required this.icon,
  required this.title,
  required this.value,
  }
  );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(
        icon,
      ),
      Text(
        title,
      ),
      Text(value)
    ]);
  }
}
