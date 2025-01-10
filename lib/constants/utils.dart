import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (files != null && files.files.isNotEmpty) {
      for (int i = 0; i < files.files.length; i++) {
        images.add(File(files.files[i].path!));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}

String formatDate(String date) {
  try {
    // Parse the date string
    final DateTime parsedDate = DateTime.parse(date);

    // Format it into the desired format
    final String formattedDate =
        DateFormat('EEEE, MMMM d, y').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle invalid date strings
    return 'Invalid date';
  }
}

String formatDateTime(String dateTime) {
  try {
    // Parse the ISO 8601 date-time string
    final DateTime parsedDateTime = DateTime.parse(dateTime);

    // Format it into the desired format
    final String formattedDateTime =
        DateFormat('EEEE, MMMM d, y h:mm a').format(parsedDateTime);

    return formattedDateTime;
  } catch (e) {
    // Handle invalid date-time strings
    return 'Invalid date-time';
  }
}
