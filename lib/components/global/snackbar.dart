// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:i_wow/components/style/theme.dart';

class SnackBarManager {
  final int duration;
  static const String DEFAULT = 'DEFAULT';
  static const String SUCCESS = 'SUCCESS';
  static const String FAILURE = 'FAILURE';
  static const String INFORM = 'INFORM';

  SnackBarManager({this.duration = 1500});

  void showSnackBar({
    required BuildContext context,
    required String content,
    String status = DEFAULT,
  }) {
    Color bodyColor = const Color(0xFFE0E2D8);
    switch (status) {
      case FAILURE:
        {
          bodyColor = AppTheme.of(context).badgeColor;
          break;
        }
      case SUCCESS:
        {
          bodyColor = Color(0xff00e032);
          break;
        }
      case INFORM:
        {
          bodyColor = AppTheme.of(context).iWowColor;
          break;
        }
    }

    final snackbar = SnackBar(
      duration: Duration(milliseconds: duration),
      behavior: SnackBarBehavior.floating,
      content: Text(
        content,
        style: AppTheme.of(context).bodyText1.copyWith(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
      ),
      backgroundColor: bodyColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void successSnackBar(BuildContext context, String title) {
    showSnackBar(content: title, context: context, status: SUCCESS);
  }

  void informSnackBar(BuildContext context, String title) {
    showSnackBar(content: title, context: context, status: INFORM);
  }

  void failureSnackBar(BuildContext context, String title) {
    showSnackBar(content: title, context: context, status: FAILURE);
  }

  void defaultSnackBar(BuildContext context, String title) {
    showSnackBar(content: title, context: context, status: DEFAULT);
  }
}
