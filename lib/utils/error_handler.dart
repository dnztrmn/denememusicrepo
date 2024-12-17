import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

void handleError(BuildContext context, dynamic error) {
  _logger.e('Error occurred: $error');

  String message = 'An error occurred';

  if (error.toString().contains('Connection failed')) {
    message = 'Please check your internet connection';
  } else if (error.toString().contains('Permission denied')) {
    message = 'Permission denied. Please check app permissions';
  } else if (error.toString().contains('Not found')) {
    message = 'Content not found';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
