import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.text,
    this.isSecondary = false,
    required this.onPressed,
    this.loading = false,
  });

  final String text;
  final bool isSecondary;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: loading ? null : onPressed,
        hoverColor: isSecondary
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        disabledColor: isSecondary
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        minWidth: double.infinity,
        elevation: 0,
        splashColor: Colors.transparent,
        height: 47,
        color: isSecondary
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        child: loading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeCap: StrokeCap.round,
                ),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.apply(
                      color: !isSecondary
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                    ),
              ));
  }
}
