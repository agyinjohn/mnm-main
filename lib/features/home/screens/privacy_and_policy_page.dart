import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor:
            GlobalVariables.backgroundColor, // Match your app's theme
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            Text(
              "Introduction",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app. Please read this policy carefully. If you do not agree with the terms of this privacy policy, please do not access the application.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Information We Collect",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We collect the following information:\n\n"
              "- Personal information, such as name, email, phone number, and address.\n"
              "- Payment details when processing transactions.\n"
              "- Location data to provide location-based services.\n"
              "- Device information for app functionality improvements.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "How We Protect Your Information",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We are committed to ensuring the safety and security of your personal information. We implement industry-standard security measures to safeguard your data, including:\n\n"
              "- Secure data encryption during transmission and storage.\n"
              "- Regular security audits to identify and address vulnerabilities.\n"
              "- Restricted access to personal information to authorized personnel only.\n"
              "- Compliance with applicable data protection laws and regulations.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "How We Use Your Information",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "Your information is used for:\n\n"
              "- Delivering products and services.\n"
              "- Processing payments.\n"
              "- Improving app functionality and user experience.\n"
              "- Sending notifications and updates.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Changes to This Policy",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We may update this Privacy Policy from time to time. We encourage you to review this policy periodically for any changes.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
