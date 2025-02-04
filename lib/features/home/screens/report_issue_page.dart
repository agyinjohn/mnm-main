import 'package:flutter/material.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _messageController = TextEditingController();

  // Support phone number
  final String supportPhone = "+233531656697"; // Replace with actual number
  final String whatsappNumber = "+233531656697"; // Replace with actual number

  // Function to make a phone call
  //  final String supportPhone = "+233531656697";
  void _callSupport() async {
    final Uri phoneUri = Uri.parse("tel:$supportPhone");
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorSnackbar("Could not launch phone dialer.");
    }
  }

  // Function to open WhatsApp chat with a pre-filled message
  void _chatOnWhatsApp() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) {
      showCustomSnackbar(
          context: context, message: 'Please enter a message before chatting.');
      return;
    }

    final Uri whatsappUri = Uri.parse(
        "https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      _messageController.clear();
    } else {
      showCustomSnackbar(context: context, message: 'Could not open WhatsApp.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Report an Issue"),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Information Card
            // Card(
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   elevation: 3,
            //   child: const Padding(
            //     padding: EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Need Help?",
            //           style:
            //               TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 8),
            //         Text(
            //           "Describe your issue and contact support.",
            //           style: TextStyle(fontSize: 16, color: Colors.grey),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const Text(
              "Need Help?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can either call support or send a message via WhatsApp.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Message Input Field
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter your issue...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons for Calling and WhatsApp Chat
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _callSupport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, size: 22),
                        SizedBox(width: 8),
                        Text("Call Support"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _chatOnWhatsApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat, size: 22),
                        SizedBox(width: 8),
                        Text("Chat on WhatsApp"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
