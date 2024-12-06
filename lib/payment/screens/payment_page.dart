import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaystackPaymentPage extends StatefulWidget {
  const PaystackPaymentPage({super.key});

  @override
  _PaystackPaymentPageState createState() => _PaystackPaymentPageState();
}

class _PaystackPaymentPageState extends State<PaystackPaymentPage> {
  final WebViewController _webViewController = WebViewController();
  String? authorizationUrl; // URL for Paystack Payment
  bool isloading = false;
  // Replace with your backend URL
  var loadingPercentage = 0;
  @override
  void initState() {
    super.initState();
    initializePayment();
  }

  Future<void> initializePayment() async {
    try {
      setState(() {
        isloading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.get('token');
      // Make a POST request to your backend to initialize payment
      // print(uri);
      final response = await http.post(
        Uri.parse('$uri/auth/initialize-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "email": "customer@example.com",
          "amount": 500000, // In Kobo
          "callbackUrl": "$uri/payment/callback",
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          authorizationUrl = data['data']['authorization_url'];
        });
        print(authorizationUrl);
      } else {
        throw Exception("Failed to initialize payment: ${response.body}");
      }
    } catch (e) {
      print("Error initializing payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error initializing payment. Please try again."),
      ));
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  void handlePaymentResult(String url) {
    if (url.contains("success")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Payment Successful!"),
      ));
      Navigator.pop(context); // Go back or update the UI accordingly
    } else if (url.contains("failed")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Payment Failed. Try again."),
      ));
      Navigator.pop(context); // Handle failure case
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authorizationUrl == null
          ? const Center(child: NutsActivityIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(authorizationUrl!),
                  ),
                ),
              ),
            ),
      // WebViewWidget(
      //     controller: _webViewController
      //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
      //       ..setNavigationDelegate(NavigationDelegate(
      //         onPageStarted: (url) {
      //           setState(() {
      //             loadingPercentage = 0;
      //           });
      //         },
      //         onProgress: (progress) {
      //           setState(() {
      //             loadingPercentage = progress;
      //           });
      //         },
      //         onPageFinished: (url) {
      //           setState(() {
      //             loadingPercentage = 100;
      //           });
      //         },
      //       ))
      //       ..loadRequest(Uri.parse(authorizationUrl!)),
      //   )
      // : WebView(
      //     initialUrl: authorizationUrl,
      //     javascriptMode: JavascriptMode.unrestricted,
      //     onWebViewCreated: (controller) {
      //       _webViewController = controller;
      //     },
      //     navigationDelegate: (navigation) {
      //       final url = navigation.url;
      //       if (url.contains("/callback")) {
      //         handlePaymentResult(url);
      //         return NavigationDecision.prevent; // Stop further navigation
      //       }
      //       return NavigationDecision.navigate;
      //     },
      //   ),
    );
  }
}
