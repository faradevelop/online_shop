import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/ui/receipt/receipt.dart';
import 'package:webview_flutter/webview_flutter.dart';



class PaymentWebView extends StatelessWidget {
  const PaymentWebView({super.key, required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
         /* onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},*/
          onNavigationRequest: (NavigationRequest request) {

            if (request.url.contains('order-complete')) {
              var uri = Uri.parse(request.url);

              //Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    ReceiptWidget(
                      id: uri.queryParameters["id"] ?? "",
                      type: uri.queryParameters["type"] ?? "",
                    ),
              ));
              if (uri.queryParameters["type"]=="success") {
                CartRepository.cartItemCountNotifier.value = 0;
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(link));

    return SafeArea(child: WebViewWidget(controller: controller));
  }
}
