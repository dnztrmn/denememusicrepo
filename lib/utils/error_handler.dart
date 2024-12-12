import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

void handleError(BuildContext context, dynamic error) {
  _logger.e('Error occurred: $error');

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        error.toString(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 3),
    ),
  );
}
