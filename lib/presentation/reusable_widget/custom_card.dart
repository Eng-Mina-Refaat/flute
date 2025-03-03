import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String textString;
  final Color color;
  const CustomCard({super.key, required this.textString, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Text(
            textString,
            style: TextStyle(
                letterSpacing: .5, wordSpacing: 4, fontSize: 20, color: color),
          ),
        ));
  }
}
