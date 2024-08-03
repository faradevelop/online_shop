import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.message,
    this.image,
    this.callToAction,
  });

  final String message;
  final Widget? image;
  final Widget? callToAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          image ?? Container(),
          const SizedBox(height: 30,),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 40,),
          callToAction ?? Container()
        ],
      ),
    );
  }
}
