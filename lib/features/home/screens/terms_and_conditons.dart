import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor:
            GlobalVariables.backgroundColor, // Match your app's theme
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              "Welcome to the M&M, Mealex and Mailex applications. By accessing or using our applications, you agree to comply with and be bound by the following terms and conditions. If you do not agree to these terms, please do not use our applications.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "User Responsibilities",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "As a user, you agree to:\n\n"
              "- Provide accurate and complete information during registration.\n"
              "- Use the app for lawful purposes only.\n"
              "- Maintain the confidentiality of your account credentials.\n"
              "- Notify us immediately of any unauthorized use of your account.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Prohibited Activities",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "You are strictly prohibited from:\n\n"
              "- Using the app to engage in fraudulent or illegal activities.\n"
              "- Interfering with the app’s operations or security.\n"
              "- Reverse-engineering or attempting to extract source code.\n"
              "- Uploading harmful or inappropriate content.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Liability Limitation",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We are not responsible for:\n\n"
              "- Any loss or damage resulting from unauthorized access to your account.\n"
              "- Interruptions or errors in the app’s performance.\n"
              "- Issues caused by third-party services integrated into the app.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Modification of Terms",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We reserve the right to update or modify these terms at any time. Continued use of the app after modifications indicates your acceptance of the updated terms.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Termination",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "We reserve the right to suspend or terminate your account at our discretion, without prior notice, for violating these terms or engaging in prohibited activities.",
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Text(
              "Governing Law",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "These terms and conditions are governed by the laws of your country of residence. Any disputes will be subject to the exclusive jurisdiction of the courts in your jurisdiction.",
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
