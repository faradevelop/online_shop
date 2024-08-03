import 'package:flutter/material.dart';

class SnackBarContentWidget extends StatelessWidget {
  const SnackBarContentWidget(
      {super.key, required this.msg, required this.icn});

  final IconData icn;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Icon(icn, color: Colors.white,), const SizedBox(width:10),Text(msg)],
    );
  }
}
