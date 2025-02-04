import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/screens/home_page.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaystackPaymentPage extends StatefulWidget {
  const PaystackPaymentPage({
    super.key,
    required this.amoutDue,
    required this.orderId,
  });
  final double amoutDue;
  final String orderId;

  @override
  _PaystackPaymentPageState createState() => _PaystackPaymentPageState();
}

class _PaystackPaymentPageState extends State<PaystackPaymentPage> {
  final WebViewController _webViewController = WebViewController();

  InAppWebViewController? _inAppWebViewController;
  String? authorizationUrl; // URL for Paystack Payment
  bool isloading = false;
  // Replace with your backend URL
  double loadingPercentage = 0;
  String? transactionId;
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
      final token = sharedPreferences.getString('x-auth-token');
      print(token);
      final decodedToken = JwtDecoder.decode(token!);

      // Make a POST request to your backend to initialize payment
      // print(uri);
      final response = await http.post(
        Uri.parse('$uri/customer/initialize-payment/${widget.orderId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "email": decodedToken['email'],
          "amount": widget.amoutDue, // In Kobo
          "callbackUrl": "$uri/payment/callback",
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          authorizationUrl =
              data['paymentGateway']['data']['authorization_url'];
          transactionId = data['localTransactionId'];
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

  // void handlePaymentResult(String url) {
  //   if (url.contains("success")) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Payment Successful!"),
  //     ));
  //     Navigator.pop(context); // Go back or update the UI accordingly
  //   } else if (url.contains("failed")) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Payment Failed. Try again."),
  //     ));
  //     Navigator.pop(context); // Handle failure case
  //   }
  // }
  Future<void> verifyPayment() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final token = sharedPreferences.getString('x-auth-token');
      if (token == null) {
        throw Exception("User not authenticated");
      }

      final response = await http.post(
        Uri.parse('$uri/customer/verify-payment/$transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print(data);
        final success = data['message'] == "success";
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Payment Successful!"),
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
          // Return success
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Payment Verification Failed."),
          ));
        }
      } else {
        throw Exception("Failed to verify payment: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error verifying payment: $e"),
      ));
    }
  }

  // void handlePaymentResult(String url) {
  //   print(url);

  //   if (reference != null) {
  //     verifyPayment(reference);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Payment Failed: Reference missing."),
  //     ));
  //     Navigator.pop(context, false);
  //   }
  //   }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        final controller = _inAppWebViewController;
        if (controller != null) {
          if (await controller.canGoBack()) {
            controller.goBack();
          }
        } else {}
      },
      child: Scaffold(
        body: authorizationUrl == null
            ? const Center(child: NutsActivityIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: InAppWebView(
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                      ),
                      initialUrlRequest: URLRequest(
                        url: WebUri(authorizationUrl!),
                      ),
                      onWebViewCreated: (controller) async {
                        _inAppWebViewController = controller;
                      },
                      onConsoleMessage: (controller, consoleMessage) =>
                          print(consoleMessage),
                      onLoadStart: (controller, url) {
                        print(url);
                      },
                      onProgressChanged: (controller, progress) {
                        setState(() {
                          loadingPercentage =
                              progress.toDouble(); // Update progress
                        });
                      },
                      onLoadStop: (controller, url) async {
                        setState(() {
                          loadingPercentage =
                              0; // Reset progress when a new page loads
                        });
                        if (url != null) {
                          // Parse the URL using Dart's Uri class
                          final String urlString =
                              url.toString(); // Convert WebUri to String
                          print('Current URL: $urlString');

                          final Uri uri = Uri.parse(urlString);
                          if (uri.queryParameters.containsKey('reference')) {
                            // Extract the reference value
                            final String? reference =
                                uri.queryParameters['reference'];
                            if (reference != null) {
                              print('Reference found: $reference');
                              // Call the verifyPayment method with the extracted reference
                              await verifyPayment();
                            }
                          } else {
                            print('Reference not found in URL');
                          }
                        }
                      }),
                ),
              ),
      ),
    );
  }
}
