import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({super.key, required this.value});
  final int value;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: value>0,
      child: Container(
        width: 19,
        height: 19,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: const TextStyle(color: Colors.white,fontSize: 15),
          ),
        ),
      ),
    );
  }
}
