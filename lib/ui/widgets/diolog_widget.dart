import 'package:flutter/material.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key, required this.onTap,
  });
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        height: 142,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: BoxDecoration(
          color: themeData.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "آیا از خروج از حساب مطمئن هستید؟",
              style: themeData.textTheme.bodyLarge!.copyWith(fontSize: 20),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ButtonWidget(
                    isSecondary: true,
                      text: 'انصراف',
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: ButtonWidget(text: 'بله', onPressed: onTap),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
