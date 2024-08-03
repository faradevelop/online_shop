import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/ui/profile/orders_list.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';

class ReceiptWidget extends StatelessWidget {
  const ReceiptWidget({super.key, required this.id, required this.type});

  final String id;
  final String type;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 22),
              decoration: BoxDecoration(
                color: themeData.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      type == "success"
                          ? CupertinoIcons.check_mark_circled_solid
                          : CupertinoIcons.xmark_circle_fill,
                      size: 70,
                      color:
                          type == "success" ? Colors.lightGreen : Colors.red),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    type == "success"
                        ? 'پرداخت با موفقیت انجام شد'
                        : "پرداخت ناموفق",
                    style: TextStyle(
                      fontSize: 24,
                      color: type == "success" ? Colors.lightGreen : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'کد رهگیری',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    id,
                    style: themeData.textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ButtonWidget(
                      text: 'رفتن به سفارشات',
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdersList(),
                            ));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
