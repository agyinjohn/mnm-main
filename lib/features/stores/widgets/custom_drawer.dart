import 'package:flutter/material.dart';
import 'package:m_n_m/constants/global_variables.dart';
import 'package:m_n_m/features/home/screens/report_issue_page.dart';
import 'package:m_n_m/features/home/widgets/show_custom_snacbar.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const String supportPhone = "+233531656697";
    void callSupport() async {
      final Uri phoneUri = Uri.parse("tel:$supportPhone");
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        showCustomSnackbar(context: context, message: 'Couldn\'t Place call');
      }
    }

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
              ),
              margin: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.cardColor,
                    backgroundImage: AssetImage(
                      'assets/images/main-logo.png',
                    ), // Replace with your logo
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Mealex & Mailex',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Shopping and Delivery Service',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Drawer items

          Expanded(
            child: ListView(
              children: [
                DrawerItem(
                  icon: Icons.report,
                  title: 'Make a Report',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportIssuePage()));
                  },
                ),
                DrawerItem(
                  icon: Icons.star_rate,
                  title: 'Rate the App',
                  onTap: () {
                    // Add functionality to rate app
                    Navigator.pop(context);
                  },
                ),
                DrawerItem(
                  icon: Icons.share,
                  title: 'Share the App',
                  onTap: () {
                    // Add functionality to share app
                    Navigator.pop(context);
                  },
                ),
                DrawerItem(
                  icon: Icons.support_agent,
                  title: 'Contact Support',
                  onTap: () {
                    // Add functionality to contact support
                    Navigator.pop(context);
                    callSupport();
                  },
                ),
                DrawerItem(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {
                    // Add functionality for About Us
                    Navigator.pop(context);
                  },
                ),
                DrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Add functionality for Settings
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Divider(color: Colors.grey.shade300),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}
